//
//  HomeView.swift
//  Slackfari
//
//  Created by Alberto Moral on 07/10/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Cocoa
import Cartography

protocol HomeViewDelegate: class {
    func didTapOnQuit()
}

class HomeView: BaseView {
    
    weak var delegate: HomeViewDelegate?
    
    lazy private var quitButton: NSButton = {
        let button = NSButton(title: "Exit", target: self, action: #selector(closeApp))
        return button
    }()
    
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
        [demoImageView, messageField, quitButton].forEach(addSubview)
    }
    
    override func addConstraints() {
        constrain(messageField, demoImageView, quitButton) { messageField, imageView, quitButton in
            messageField.top == messageField.superview!.top + 8
            messageField.leading == messageField.superview!.leading
            messageField.trailing == quitButton.trailing - 8
            
            imageView.top == messageField.bottom + 8
            imageView.leading == imageView.superview!.leading
            imageView.trailing == imageView.superview!.trailing
            imageView.bottom == imageView.superview!.bottom
            
            quitButton.top == quitButton.superview!.top + 8
            quitButton.trailing == quitButton.superview!.trailing - 8
        }
    }
    
    // Action
    
    func closeApp() {
        delegate?.didTapOnQuit()
    }
}
