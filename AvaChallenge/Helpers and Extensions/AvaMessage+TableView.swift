//
//  AvaMessage+TableView.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/8/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import UIKit

extension AvaMessageCenter {
    func message(atIndexPath indexPath: NSIndexPath) -> AvaMessage? {
        guard indexPath.row < messageCount else { return nil }
        let blockId = messageKeys[indexPath.row]
        return messages[blockId]
    }
}
