//
// Created by Richard Martinez on 8/8/16.
// Copyright (c) 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation

///
/// AvaMessage
/// ================
/// `AvaMessag` is a struct that encapsulates the message data received from
/// Ava's PubNub Messaging service
///
/// * * * * * *
/// - Author: Richard 'Shah' Martinez
struct AvaMessage {
    let user: AvaUser
    let blocId: BlocID
    var messageBody: String?
}


extension AvaMessage: CustomStringConvertible {
    var description: String {
        return "Message: \n" + "--------\n" + "Userid: \(user.userId)\n" +
            "username: \(user.userName)\n" + "blocId: \(blocId)" +
        "\(messageBody)"
    }
}

extension AvaMessage: CustomDebugStringConvertible {
    var debugDescription: String {
        return description
    }
}

// MARK: - Equatable Protocol
func ==(lhs: AvaMessage, rhs: AvaMessage) -> Bool {
    return lhs.blocId == rhs.blocId
}
extension AvaMessage: Equatable { }

// MARK: Hashable Protocol
extension AvaMessage: Hashable {
    var hashValue: Int { return blocId.hashValue }
}