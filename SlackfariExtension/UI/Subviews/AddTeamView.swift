//
//  AddTeamView.swift
//  Slackfari
//
//  Created by Alberto Moral on 01/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa
import Cartography

protocol AddTeamViewDelegate: class {
    func didTapOnCloseButton()
    func didTapOnAddTeamButton(teamName: String, token: String)
}

class AddTeamView: NSView {
    weak var delegate: AddTeamViewDelegate?
    
    lazy var closeButton: NSButton = {
        let button = NSButton(title: "Close", target: self, action: #selector(closeView))
        return button
    }()
    
    lazy var addButton: NSButton = {
        let button = NSButton(title: "Add", target: self, action: #selector(addTeam))
        return button
    }()
    
    let nameField: NSTextField = {
        let field = NSTextField()
        field.placeholderString = "Add Team Name"
        return field
    }()
    
    let tokenField: NSTextField = {
        let field = NSTextField()
        field.placeholderString = "Add Token"
        return field
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        wantsLayer = true
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        layer?.backgroundColor = NSColor.blue.cgColor
        addSubview(closeButton)
        addSubview(addButton)
        addSubview(nameField)
        addSubview(tokenField)
    }
    
    func closeView() {
        delegate?.didTapOnCloseButton()
    }
    
    func addTeam() {
        Swift.print("name \(nameField.stringValue) with token \(tokenField.stringValue)")
        delegate?.didTapOnAddTeamButton(teamName: nameField.stringValue, token: tokenField.stringValue)
    }
    
    private func addConstraints() {
        constrain(nameField, tokenField, closeButton, addButton) { nameField, tokenField, closeButton, addButton in
            nameField.top == nameField.superview!.top + 30
            nameField.leading == nameField.superview!.leading + 8
            nameField.trailing == nameField.superview!.trailing - 8
            
            tokenField.top == nameField.bottom + 8
            tokenField.leading == tokenField.superview!.leading + 8
            tokenField.trailing == tokenField.superview!.trailing - 8
            
            closeButton.top == closeButton.superview!.top + 8
            closeButton.trailing == closeButton.superview!.trailing - 8
            
            addButton.bottom == addButton.superview!.bottom - 8
            addButton.trailing == addButton.superview!.trailing - 8
        }
    }
}
