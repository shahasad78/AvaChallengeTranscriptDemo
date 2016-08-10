//
// Created by Richard Martinez on 8/8/16.
// Copyright (c) 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import Foundation

///
/// AvaUser
/// =======
/// `AvaUser` is a lightweight abstraction of an AvaUser
///
/// * * * * * *
/// - Author: Richard 'Shah' Martinez
class AvaUser {

    let userId: String
    let userName: String

    init(userId: String, userName: String) {
        self.userId = userId
        self.userName = userName
    }

}

// MARK: - Equatable Protocol
func ==(lhs: AvaUser, rhs: AvaUser) -> Bool {
    return lhs.userId == rhs.userId
}
extension AvaUser: Equatable { }

// MARK: - Hashable Protocol
extension AvaUser: Hashable {
    var hashValue: Int { return userId.hashValue }
}