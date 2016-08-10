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

/// `AvaMessageCenter` is a singleton class that manages the access of
/// Ava's PubNub Messaging service
class AvaMessageCenter: NSObject {

    typealias JSONDictionary = [String:AnyObject] // FIXME: Unused
    typealias MessageClusterKey = (userId: UserID, userName: UserName)
    typealias CallBackFunction = (Bool) -> ()

    enum AvaMessageKey: String {
        case blocId
        case requestCommand
        case speakerId
        case transcript
    }

    /// `users` stores up to five users in chat room
    var users = [AvaUser]()

    var messages = [BlocID:AvaMessage]()
    var messageKeys = [BlocID]()
    var messageClusterKeys = [AvaUser]()
    var messageClusters = [AvaMessageCluster]()
    var clusterCount: Int {
        return messageClusters.count
    }

    var delegate: AvaMessageCenterDelegate?
    private var callback: CallBackFunction?

    static let sharedCenter = AvaMessageCenter()
    let client: PubNub? = {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.client
    }()

    private override init() {
        super.init()

        if let client = client {
            client.addListener(self)
        }
    }

    func addMessageCallback(callback: CallBackFunction) {
        self.callback = callback
    }




}



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
        // Select last object from list of channels and send message to it.
        let targetChannel = "00001aa2"
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
