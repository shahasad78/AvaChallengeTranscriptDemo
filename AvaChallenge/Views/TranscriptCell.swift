//
// Created by Richard Martinez on 8/9/16.
// Copyright (c) 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import UIKit

class TranscriptCell: UITableViewCell {

    @IBOutlet weak var transcriptTextView: UITextView!

    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        setupCell()
    }

    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        setupCell()
    }

    // MARK: - Setup Methods
    func setupCell() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        transcriptTextView.addGestureRecognizer(tapRecognizer)
    }

    func handleTap(recognizer: UITapGestureRecognizer) {
        if let textView = recognizer.view as? UITextView {
            print("Word Tapped: ")
            let tapLocationInView: CGPoint = recognizer.locationInView(textView)
            let position = CGPoint(x: tapLocationInView.x, y: tapLocationInView.y)
            // get location of selected text at the tap position
            if let tapPosition: UITextPosition = transcriptTextView.closestPositionToPoint(position),
                let selectedTextRange = transcriptTextView.tokenizer.rangeEnclosingPosition(tapPosition,
                                                                                            withGranularity: .Word,
                                                                                            inDirection: UITextLayoutDirection.Right.rawValue),
                let tappedWord = transcriptTextView.textInRange(selectedTextRange) {
                print("Word Tapped: " + tappedWord)
            }

        }
    }

}
