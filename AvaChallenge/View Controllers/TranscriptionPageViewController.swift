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

        tableView.estimatedRowHeight = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool)  {
        super.viewDidAppear(animated)
        tableView.scrollToBottom()
    }
}

extension TranscriptionPageViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageCenter.messageCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath)
        cell.textLabel?.text = messageCenter.messages[indexPath.row].user.userName
        cell.detailTextLabel?.text = messageCenter.messages[indexPath.row].messageBody
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