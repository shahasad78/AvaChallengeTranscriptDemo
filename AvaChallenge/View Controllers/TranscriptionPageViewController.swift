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
        let nib = UINib(nibName: String(TranscriptHeaderView), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(TranscriptHeaderView))

        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorColor = UIColor.clearColor()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 20
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        // ===========================================================

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
        // ==========================

    }

//    // MARK: - Text Selection Methods
//    func setupGestureRecognizer(textView: UITextView) {
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tapRecognizer.numberOfTapsRequired = 1
//        textView.addGestureRecognizer(tapRecognizer)
//    }
//
//    func handleTap(recognizer: UITapGestureRecognizer) {
//        print("Word Tapped: ")
//        if let textView = recognizer.view as? UITextView {
//            let tapLocationInView: CGPoint = recognizer.locationInView(textView)
//            let position = CGPoint(x: tapLocationInView.x, y: tapLocationInView.y)
//            // get location of selected text at the tap position
//            if let tapPosition: UITextPosition = textView.closestPositionToPoint(position),
//                let selectedTextRange = textView.tokenizer.rangeEnclosingPosition(tapPosition,
//                                                                                            withGranularity: .Word,
//                                                                                            inDirection: UITextLayoutDirection.Right.rawValue),
//                let tappedWord = textView.textInRange(selectedTextRange) {
//                print(tappedWord)
//            }
//
//        }
//    }
}

extension TranscriptionPageViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messageCenter.clusterCount
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageCenter.messageClusters[section].messageCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TranscriptCell), forIndexPath: indexPath) as! TranscriptCell
        // If the user is different than the user from the previous post, Display the user name.
        if let message = messageCenter.message(atIndexPath: indexPath) {
            cell.transcriptTextView?.text = message.messageBody
        }
//        setupGestureRecognizer(cell.transcriptTextView)
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

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // FIXME:  This cell is nil
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(TranscriptHeaderView))
        if let header = cell as? TranscriptHeaderView {
            header.userNameLabel.text = messageCenter.titleForSection(section)
            return header
        }
        return cell
    }


}