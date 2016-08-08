//
//  ProfileIconView.swift
//  AvaChallenge
//
//  Created by Richard Martinez on 8/7/16.
//  Copyright © 2016 PhantomUniversalMediaProductions. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileIconView: UIView {

    @IBInspectable var letterLabel =  UILabel()
    let fontSize: CGFloat = {
        let scaleCoefficient = UIScreen.mainScreen().nativeScale
        let screenBounds = UIScreen.mainScreen().nativeBounds
        return screenBounds.height <= 960 ? 36 : 52
    }()

    @IBInspectable var name: String = "" {
        didSet {
            if !name.isEmpty {
                let firstLetter = name.substringToIndex(name.startIndex.successor())
                letterLabel.text = firstLetter
                setNeedsLayout()
            }
        }
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init(coder:)")
        print("\(self)")
//        setupView()
    }

    func setupView() {
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false

        letterLabel.font = letterLabel.font.fontWithSize(fontSize)
        letterLabel.adjustsFontSizeToFitWidth = true
        letterLabel.allowsDefaultTighteningForTruncation = true
        letterLabel.textAlignment = .Center
        letterLabel.textColor = UIColor.whiteColor()
        letterLabel.minimumScaleFactor = 0.25

        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        self.addSubview(letterLabel)

        if name.isEmpty { name = "Unknown" }

        if let centerPoint = self.superview?.convertPoint(self.center, toView: self) {
            letterLabel.center = centerPoint
            letterLabel.frame = self.frame
        }
        let letterConstraints = [
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-(10)-[letter]-(10)-|", options: [], metrics: nil, views: ["letter": letterLabel]),
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(10)-[letter]-(10)-|", options: [], metrics: nil, views: ["letter": letterLabel])
        ]
        NSLayoutConstraint.activateConstraints(letterConstraints.flatten().flatMap {$0})

    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    override func prepareForInterfaceBuilder() {
       setupView()
    }




    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        setupView()
//        letterLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
//        letterLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        print("\(letterLabel)")
    }


}
