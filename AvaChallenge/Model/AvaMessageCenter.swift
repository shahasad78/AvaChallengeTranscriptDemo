//
//  AvaMessageCenter.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/8/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation
import PubNub

protocol AvaMessageCenterDelegate: class {
    func didReceive(message: AvaMessage)
}

/// `AvaMessageCenter` is a singleton class that manages the access of
/// Ava's PubNub Messaging service
class AvaMessageCenter: NSObject {

    typealias BlocID = UInt
    typealias JSONDictionary = [String:AnyObject] // FIXME: Unused
    typealias CallBackFunction = () -> ()

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
    var messageCount: Int {
        return messages.count
    }

    weak var delegate: AvaMessageCenterDelegate?
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

    func addMessageCallback(_ callback: CallBackFunction) {
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

            guard let blocId = UInt(blocId) else { return }
            let avaMessage  = AvaMessage(user: AvaUser(userId: userId, userName: "User"), messageBody: transcript)
            messages[blocId] = avaMessage
            if blocId != messageKeys.last {
                messageKeys.append(blocId)
            }
            if let callback = callback { callback() }
//            print(messagePacket)

//            do {
//                try avaMessage = messa
//            }


        }
//        if let messageData = NSJSONSerialization.dataWithJSONObject(message.data, options: [.PrettyPrinted]) {
//            // Check if blocId exists in array and either overwrite existing AvaMessage or add new.
//
//            guard let blockId = UInt(messageData[AvaMessageKey.blocId.rawValue] as! String) else { return }
//            if var message = messages[blockId] {
//                message.messageBody = messageData[AvaMessageKey.transcript.rawValue] as? String
//            } else {
//                messageKeys.append(blockId)
//                let user = AvaUser(userId: "00001aa2", userName: "Shah Martinez")
//                let avaMessage = AvaMessage(user: user, messageBody: messageData[AvaMessageKey.transcript.rawValue] as! String)
//                messages[blockId] = avaMessage
//            }
//
//
//        }
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
