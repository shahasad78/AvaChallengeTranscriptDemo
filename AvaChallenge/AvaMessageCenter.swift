//
//  AvaMessageCenter.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/8/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation

/// `AvaMessageCenter` is a singleton class that manages the access of
/// Ava's PubNub Messaging service
class AvaMessageCenter {

    static let sharedCenter = AvaMessageCenter()

    private init() {
        // TODO: Delete this code when PubNub is working
        users.appendContentsOf([
                AvaUser(userId: "011000434", userName: "Shah Martinez"),
                AvaUser(userId: "011000435", userName: "Katie Burr")
        ])

        var currentUser: Bool = false
        self.messages = ["Welcome to Ava", "Hey You!", "What it do Baby boo?!?",
                         "Nothing much honey butter chicken biscuit.", " You like this app I made for the hard-of-hearing?",
                        "Deaf-initely"].map {
            let user = users[currentUser.intValue()]
            currentUser = !currentUser
            return AvaMessage(user: user, messageBody: $0)
        }

    }

    /// `users` stores up to five users in chat room
    var users = [AvaUser]()

    var messages = [AvaMessage]()
    var messageCount: Int { return messages.count }




}

extension  Bool {
    func intValue() -> Int {
        return self ? 1 : 0
    }
}
