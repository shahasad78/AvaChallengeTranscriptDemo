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
        guard indexPath.section < messageClusters.count else { return nil }
        let cluster = messageClusters[indexPath.section]
        return cluster[indexPath.row]
    }
}
