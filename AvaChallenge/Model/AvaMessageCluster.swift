//
//  AvaMessageCluster.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/10/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation

class AvaMessageCluster {

    let user: AvaUser
    var messages: [BlocID: AvaMessage]

    private var messageKeys = [BlocID]()
    // ---------------------------------
    // Convenience Properties
    // ---------------------------------
    var userId: UserID { return user.userId }
    var messageCount: Int { return messageKeys.count }
    var currentBlocID: BlocID? { return messages.keys.sort().last }
    var cluster: [AvaMessage] { return messageKeys.map { messages[$0]! } }
    var stringCluster: [String] { return messageKeys.map { (messages[$0]?.messageBody)! } }
    // =================================


    init(user: AvaUser, message: AvaMessage) {
        self.user = user
        self.messages = [message.blocId: message]
        self.messageKeys.append(message.blocId)
    }

    init(user: AvaUser, messages: [AvaMessage]) {
        self.user = user
        var dict = [BlocID: AvaMessage]()
        messages.forEach { dict[$0.blocId] = $0 }
        messageKeys = messages.map { $0.blocId }.sort()
        self.messages = dict
    }

    func add(message message: AvaMessage) {
        let isNewMessage =  messages[message.blocId] == nil
        if isNewMessage { messageKeys.append(message.blocId) }
        messages[message.blocId] = message
//        print("Adding Message: \(message)")
        print(messages)
    }

    subscript(index: Int) -> AvaMessage? {
        get {
            guard index < messageKeys.count else { return nil }
            let key = messageKeys[index]
            return messages[key]
        }

    }


}