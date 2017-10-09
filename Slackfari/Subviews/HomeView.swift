//
//  HomeView.swift
//  Slackfari
//
//  Created by Alberto Moral on 07/10/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Cocoa
import Cartography

class HomeView: BaseView {
    let demoImageView: NSImageView = {
        let imageView = NSImageView(frame: .zero)
        imageView.image = NSImage(named: "demo")
        return imageView
    }()
    
    let messageField: NSTextField = {
        let field = NSTextField(frame: .zero)
        field.isSelectable = false
        field.isBordered = false
        field.isEditable = false
        field.alignment = .center
        field.maximumNumberOfLines = 2
        field.stringValue = "Now you can send messages to your Slack teams! \n Go to Safari and select the Safari Extension, the next popup will appear"
        return field
    }()
    
    override func addSubviews() {
        [demoImageView, messageField].forEach(addSubview)
    }
    
    override func addConstraints() {
        constrain(messageField, demoImageView) { messageField, imageView in
            messageField.top == messageField.superview!.top + 8
            messageField.leading == messageField.superview!.leading
            messageField.trailing == messageField.superview!.trailing
            
            imageView.top == messageField.bottom + 8
            imageView.leading == imageView.superview!.leading
            imageView.trailing == imageView.superview!.trailing
            imageView.bottom == imageView.superview!.bottom
        }
    }
}
