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

    var heightAtIndexPath = [NSIndexPath:CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // -------------------------
        // Setup TableView
        // -------------------------
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clearColor()
        tableView.rowHeight = UITableViewAutomaticDimension

        // -------------------------
        // Setup AvaMessageCenter
        // -------------------------
        messageCenter.addMessageCallback({ [weak self] (isNewMessage) in
            dispatch_async(dispatch_get_main_queue()) {
                self?.tableView.reloadData()
                if isNewMessage {
                    self?.tableView.scrollToBottom()
                }
            }
        })


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
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TranscriptCell), forIndexPath: indexPath) as! TranscriptCell
        // If the user is different than the user from the previous post, Display the user name.
        if let message = messageCenter.message(atIndexPath: indexPath) {
            var userName: String? = nil
            if indexPath.row > 0 {
                let previousIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
                if let previousMessage = messageCenter.message(atIndexPath: previousIndexPath) {
//                    if message.user.userId == previousMessage.user.userId { cell.userLabel.removeFromSuperview() }
                    cell.userLabel.hidden = message.user.userId == previousMessage.user.userId
//                    if message.user.userId != previousMessage.user.userId {
//                        userName = message.user.userName
//                    }
                }
            } else {
                userName = message.user.userName
            }
            cell.userLabel?.text = userName
            cell.transcriptTextView?.text = message.messageBody
        }

        return cell
    }


}

extension  TranscriptionPageViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Add contents of selected Row to Speech Queue. Enable Speech Button
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: Remove selected text from speech Queue. Disable speech button
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = heightAtIndexPath[indexPath] {
            return height
        } else {
            return UITableViewAutomaticDimension
        }
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let height = cell.frame.height
        heightAtIndexPath[indexPath] = height
    }


}