//
//  AvaMessageCluster.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/10/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation

// TODO: Conform AvaMessageCluster to CollectionType

/// An `AvaMessageCluster` stores all of the contiguous messages sent by a given user
/// Messages can be retrieved using subscripts of types `BlocID` and `Int`
/// - example:
/// ```
/// let lastMessage = cluster[cluster.messageCount - 1]
/// ```
class AvaMessageCluster {

    let user: AvaUser
    private var messages: [BlocID: AvaMessage]

    private var messageKeys = [BlocID]()

    // ---------------------------------
    // Convenience Properties
    // ---------------------------------
    var userId: UserID { return user.userId }
    var messageCount: Int { return messages.count }
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
    }

    subscript(blocId: BlocID) -> AvaMessage? {
        get {
            return messages[blocId]
        }
    }

    subscript(index: Int) -> AvaMessage? {
        get {
            guard index < messageKeys.count else { return nil }
            let key = messageKeys[index]
            return messages[key]
        }
    }
}