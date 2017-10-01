//
//  SafariExtensionView.swift
//  SlackfariExtension
//
//  Created by Alberto Moral on 27/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa
import Cartography

protocol SafariExtensionViewDelegate: class {
    func didTapOnSendMessage()
    func didTapOnAddTeam()
}

class SafariExtensionView: NSView {
    
    weak var delegate: SafariExtensionViewDelegate?
    
    var scrollViewTableView = NSScrollView()
    var scrollViewCollectionView = NSScrollView()
    
    lazy var collectionView: NSCollectionView = {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collection = NSCollectionView()
        collection.collectionViewLayout = flowLayout
        collection.isSelectable = true
        collection.register(TeamCollectionViewItem.self, forItemWithIdentifier: "TeamCollectionViewItem")
        return collection
    }()
    
    var tableView: NSTableView = {
        let table = NSTableView(frame: .zero)
        table.rowSizeStyle = .large
        table.backgroundColor = Stylesheet.color(.clear)
        
        let column = NSTableColumn(identifier: "column")
        table.headerView = nil
        column.width = 1
        table.addTableColumn(column)
        return table
    }()
    
    var teamNameLabel: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
        textField.isEditable = false
        textField.stringValue = "Channel Name"
        textField.backgroundColor = Stylesheet.color(.clear)
        return textField
    }()
    
    var notificationLabel: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
        textField.isEditable = false
        textField.stringValue = "Last message sent to: "
        textField.font = NSFont.systemFont(ofSize: 10)
        textField.backgroundColor = Stylesheet.color(.clear)
        return textField
    }()
    
    var messageField: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
        textField.isHighlighted = false
        textField.focusRingType = .none
        textField.placeholderString = "Message to send"
        return textField
    }()
    
    lazy var sendButton: NSButton = {
        let button = NSButton(title: "Send", target: self, action: #selector(sendMessage))
        return button
    }()
    
    lazy var addButton: NSButton = {
        let button = NSButton(title: "Add", target: self, action: #selector(addTeam))
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    func setup() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        scrollViewTableView.documentView = tableView
        scrollViewCollectionView.documentView = collectionView
        
        [scrollViewTableView, scrollViewCollectionView, teamNameLabel, sendButton, addButton, messageField, notificationLabel].forEach(addSubview)
    }
    
    private func addConstraints() {
        constrain(teamNameLabel, messageField, scrollViewTableView, sendButton, notificationLabel) { teamNameLabel, messageField, scrollViewTableView, sendButton, notificationLabel in
            
            notificationLabel.top == teamNameLabel.bottom + Stylesheet.margin(.small)
            notificationLabel.leading == teamNameLabel.leading
            notificationLabel.trailing == teamNameLabel.trailing
            notificationLabel.height == 20
            
            messageField.leading == messageField.superview!.leading + Stylesheet.margin(.small)
            messageField.trailing == messageField.superview!.trailing - Stylesheet.margin(.small)
            messageField.top == notificationLabel.bottom + Stylesheet.margin(.small)
            messageField.height == Configuration.MessageField.height
            
            scrollViewTableView.top == messageField.bottom + Stylesheet.margin(.medium)
        }
        
        constrain(teamNameLabel, sendButton, tableView, scrollViewTableView, scrollViewCollectionView) { teamNameLabel, sendButton, tableView, scrollViewTableView, scrollViewCollectionView in
            teamNameLabel.centerY == sendButton.centerY
            teamNameLabel.leading == teamNameLabel.superview!.leading + Stylesheet.margin(.medium)
            teamNameLabel.trailing == sendButton.leading
            
            sendButton.top == sendButton.superview!.top + Stylesheet.margin(.medium)
            sendButton.trailing == sendButton.superview!.trailing - Stylesheet.margin(.medium)
            sendButton.width == 60
            
            tableView.top == tableView.superview!.top + Stylesheet.margin(.big)
            tableView.leading == tableView.superview!.leading
            tableView.trailing == tableView.superview!.trailing
            tableView.bottom == tableView.superview!.bottom
            tableView.height == Configuration.Screen.height
            tableView.width == Configuration.Screen.width
            
            scrollViewTableView.leading == scrollViewTableView.superview!.leading + Stylesheet.margin(.small)
            scrollViewTableView.trailing == scrollViewTableView.superview!.trailing - Stylesheet.margin(.small)
            scrollViewTableView.bottom == scrollViewCollectionView.top - Stylesheet.margin(.small)
        }
        
        constrain(scrollViewCollectionView, addButton) { scrollViewCollectionView, addButton in
            addButton.bottom == addButton.superview!.bottom - Stylesheet.margin(.medium)
            addButton.trailing == addButton.superview!.trailing - Stylesheet.margin(.medium)
            
            scrollViewCollectionView.bottom == scrollViewCollectionView.superview!.bottom - Stylesheet.margin(.small)
            scrollViewCollectionView.leading == scrollViewCollectionView.superview!.leading + Stylesheet.margin(.small)
            scrollViewCollectionView.trailing == addButton.leading - Stylesheet.margin(.medium) - Stylesheet.margin(.small)
            scrollViewCollectionView.height == Configuration.TeamCollectionView.height
        }
    }
    
    // MARK: Actions
    
    func sendMessage() {
        delegate?.didTapOnSendMessage()
    }
    
    func addTeam() {
        delegate?.didTapOnAddTeam()
    }
}
