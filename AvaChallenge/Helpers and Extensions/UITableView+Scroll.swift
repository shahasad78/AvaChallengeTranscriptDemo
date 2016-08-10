//
// Created by Richard Martinez on 8/8/16.
// Copyright (c) 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom()  {
        print("Scrolling Message Received")
        let section = numberOfSections > 0 ? numberOfSections - 1 : 0
        if numberOfRowsInSection(section) > 0 {
            let indexPath = NSIndexPath(forRow: numberOfRowsInSection(section) - 1 , inSection: section)
            scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        }
    }
}
