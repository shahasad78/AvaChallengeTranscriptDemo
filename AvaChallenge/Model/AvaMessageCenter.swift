//
//  AvaMessageCenter.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/8/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation
import PubNub

protocol AvaMessageCenterDelegate {
    func didReceive(message: AvaMessage)
}

typealias BlocID = UInt
typealias UserID = String
typealias UserName = String


///
/// AvaMessageCenter
/// ================
/// `AvaMessageCenter` is a *singleton* class that manages the access to
/// Ava's PubNub Messaging service
///
///
/// You can register a callBack with the message center by using the `addCallBack(_:)` method.  
/// This callback will be called when a message is received from the server.
/// * * * * * *
/// - Author: Richard 'Shah' Martinez
class AvaMessageCenter: NSObject {

    typealias CallBackFunction = (Bool) -> ()

    private enum AvaMessageKey: String {
        case blocId
        case requestCommand
        case speakerId
        case transcript
    }

    /// PubNub object handles connection to PubNub server.
    private var client: PubNub?
//    = {
//        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        return delegate.client
//    }()

    private var userId: UserID?

    /// `users` stores up to five users in chat room
    private(set) var users = [AvaUser]() // TODO: Populate Current Users in chatroom
    var messageClusters = [AvaMessageCluster]()
    var clusterCount: Int {
        return messageClusters.count
    }

    // ----------------------------------------
    // DELEGATES AND CALLBACKS
    // ----------------------------------------
    var delegate: AvaMessageCenterDelegate?
    private var callback: CallBackFunction? // TODO: Make this a one->many relationship

    /// Singleton instance of AvaMessageCenter.
    static let sharedCenter = AvaMessageCenter()



    // ----------------------------------------
    // INITIALIZERS
    // ----------------------------------------
    private override init() {
        super.init()

        guard let clientInfoPath = NSBundle.mainBundle().pathForResource("ClientInfo", ofType: "plist"),
           let clientInfo = NSDictionary(contentsOfURL: NSURL(fileURLWithPath: clientInfoPath)),
            let userId = (clientInfo["userId"] as? UserID) else {
            fputs("ERROR: Could not access user data", stderr)
            return
        }
        self.userId = userId
        let configuration = PNConfiguration(publishKey: "pub-c-6590f75c-b2bb-4acc-9922-d5fe5aa8dec9",
        subscribeKey: "sub-c-897a7150-da55-11e5-9ce2-0619f8945a4f")
        configuration.uuid = self.userId ?? ""
        self.client = PubNub.clientWithConfiguration(configuration)
        client?.addListener(self)

        self.client?.subscribeToChannels([self.userId ?? ""], withPresence: true)




    }
    // ========================================

    // ----------------------------------------
    // ACCESSORS
    // ----------------------------------------
    func addMessageCallback(callback: CallBackFunction) {
        self.callback = callback
    }
    // ========================================
}

// -----------------------------------------------------
// MARK: - PubNub EventListener Callback Methods
// -----------------------------------------------------
extension AvaMessageCenter:  PNObjectEventListener {
    func client(_ client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        if message.data.actualChannel != nil {

        } else {

        }

        if let messagePacket = message.data.message,
            let blocId = messagePacket[AvaMessageKey.blocId.rawValue] as? String,
            let userId = messagePacket[AvaMessageKey.speakerId.rawValue] as? String,
            let transcript = messagePacket[AvaMessageKey.transcript.rawValue] as? String {

            // ---------------------
            // Flags
            // ---------------------
            var isNewMessage = false
            var isNewUser = false
            // =====================


            guard let blocId = UInt(blocId) else { return }
            let avaMessage  = AvaMessage(user: AvaUser(userId: userId, userName: "User"), blocId: blocId , messageBody: transcript)

            var currentCluster: AvaMessageCluster
            if let _ = messageClusters.last {
                currentCluster = messageClusters.last!
            } else {
                currentCluster = AvaMessageCluster(user: avaMessage.user, message: avaMessage)
                messageClusters.append(currentCluster)
                isNewUser = true
                // else append message to current cluster
                if let callback = callback { callback(isNewUser) }
                return
            }

            // if newUser add New CLuster
            if avaMessage.user != currentCluster.user {
                isNewUser = true
                isNewMessage = true
                let newCluster = AvaMessageCluster(user: avaMessage.user, message: avaMessage)
                messageClusters.append(newCluster)
            } else { // Not a new user, add message to existing cluster
                if blocId != currentCluster.currentBlocID { isNewMessage = true }
                currentCluster.add(message: avaMessage)
            }


            // else append message to current cluster
            if let callback = callback { callback(isNewUser) }
        }

//        print("Received message: \(message.data.message) on channel " +
//                "\((message.data.actualChannel ?? message.data.subscribedChannel)!) at " +
//                "\(message.data.timetoken)")

    }

    func client(_ client: PubNub!, didReceivePresenceEvent event: PNPresenceEventResult!) {
        print(event.data)

    }

    func client(_ client: PubNub!, didReceiveStatus status: PNStatus!) {

        if status.operation == .SubscribeOperation {
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                let subscribeStatus: PNSubscribeStatus =  status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    // There was no error
                } else {
                    // The subscriber was temprorarily disconnected
                    fputs("User was temporarily disconnected", stderr)
                }
            }
            else {
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    let message = "PubNub Access Manager cannot grant access to the client: \(self.userId)"
                    fputs(message.cStringUsingEncoding(NSUTF8StringEncoding)!, stderr)
                }
                else if errorStatus.category == .PNUnexpectedDisconnectCategory {
                    fputs("There was an unexpected error with your internet connection", stderr)
                }

            }

        }
        // Select last object from list of channels and send message to it.
        if let targetChannel = self.userId {
            client.publish("Hello from the AvaChallenge Test Device", toChannel: targetChannel,
                    compressed: false, withCompletion: { (status) -> Void in

                if !status.error {

                    // Message successfully published to specified channel.
                } else {

                    // Handle message publish error. Check 'category' property
                    // to find out possible reason because of which request did fail.
                    // Review 'errorData' property (which has PNErrorData data type) of status
                    // object to get additional information about issue.
                    //
                    // Request can be resent using: status.retry()
                }
            })
        }

    }

}
// =====================================================

