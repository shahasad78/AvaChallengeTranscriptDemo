//
//  ViewController.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/7/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import UIKit

class TranscriptionPageViewController: UIViewController {

    let messageCenter = AvaMessageCenter.sharedCenter
    let audioManager = AudioManager()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clearColor()

        messageCenter.addMessageCallback({ [weak self] in
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.tableView.reloadData()
                // TODO: Fix jerky scrolling
                self?.tableView.scrollToBottom()
            }
        })

        tableView.estimatedRowHeight = 22
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
//        tableView.scrollToBottom()
    }
}

extension TranscriptionPageViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageCenter.messageCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath)
        // If the user is different than the user from the previous post, Display the user name.
        if let message = messageCenter.message(atIndexPath: indexPath) {
            var userName: String? = nil
            if indexPath.row > 0 {
                let previousIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
                if let previousMessage = messageCenter.message(atIndexPath: previousIndexPath) {
                    if message.user.userId != previousMessage.user.userId {
                        userName = message.user.userName
                    }
                }
            } else {
                userName = message.user.userName
            }
            cell.textLabel?.text = userName
            cell.detailTextLabel?.text = message.messageBody
        }

//        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        return cell
    }
}

extension  TranscriptionPageViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Add contents of selected Row to Speech Queue. Enable Speech Button
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Remove seleced text from speech Queue. Disable speech button
    }

}