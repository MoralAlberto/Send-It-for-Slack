/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import Cocoa
import Cartography

protocol AddTeamViewDelegate: class {
    func didTapOnCloseButton()
    func didTapOnAddTeamButton(teamName: String, token: String)
}

class AddTeamView: BaseView {
    weak var delegate: AddTeamViewDelegate?
    
    lazy private var closeButton: NSButton = {
        let button = NSButton(title: "Close", target: self, action: #selector(closeView))
        return button
    }()
    
    lazy private var addButton: NSButton = {
        let button = NSButton(title: "Add", target: self, action: #selector(addTeam))
        return button
    }()
    
    lazy private var nameField: NSTextField = {
        let field = NSTextField()
        field.placeholderString = "Add Team Name"
        field.nextKeyView = self.tokenField
        return field
    }()
    
    lazy private var tokenField: NSTextField = {
        let field = NSTextField()
        field.placeholderString = "Add Token"
        return field
    }()
    
    override func setup() {
        wantsLayer = true
        addSubviews()
        addConstraints()
    }
    
    override func addSubviews() {
        layer?.backgroundColor = Stylesheet.color(.mainLightGray).cgColor
        [closeButton, addButton, nameField, tokenField].forEach(addSubview)
    }
    
    override func addConstraints() {
        constrain(nameField, tokenField, closeButton, addButton) { nameField, tokenField, closeButton, addButton in
            nameField.top == nameField.superview!.top + Stylesheet.margin(.big) + Stylesheet.margin(.medium) + Stylesheet.margin(.small)
            nameField.leading == nameField.superview!.leading + Stylesheet.margin(.medium)
            nameField.trailing == nameField.superview!.trailing - Stylesheet.margin(.medium)
            
            tokenField.top == nameField.bottom + Stylesheet.margin(.medium)
            tokenField.leading == tokenField.superview!.leading + Stylesheet.margin(.medium)
            tokenField.trailing == tokenField.superview!.trailing - Stylesheet.margin(.medium)
            
            closeButton.top == closeButton.superview!.top + Stylesheet.margin(.medium)
            closeButton.trailing == closeButton.superview!.trailing - Stylesheet.margin(.medium)
            
            addButton.bottom == addButton.superview!.bottom - Stylesheet.margin(.medium)
            addButton.trailing == addButton.superview!.trailing - Stylesheet.margin(.medium)
        }
    }
    
    func closeView() {
        delegate?.didTapOnCloseButton()
    }
    
    func addTeam() {
        delegate?.didTapOnAddTeamButton(teamName: nameField.stringValue, token: tokenField.stringValue)
    }
}
