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
        column.width = 200
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
    
    var messageField: NSTextField = {
        let textField = NSTextField()
        textField.isBordered = false
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
        addSubview(scrollViewTableView)
        addSubview(scrollViewCollectionView)
        addSubview(teamNameLabel)
        addSubview(sendButton)
        addSubview(addButton)
        addSubview(messageField)
    }
    
    private func addConstraints() {
        constrain(teamNameLabel, messageField, scrollViewTableView, sendButton) { teamNameLabel, messageField, scrollViewTableView, sendButton in
            messageField.leading == messageField.superview!.leading
            messageField.trailing == messageField.superview!.trailing
            messageField.top == sendButton.bottom + Stylesheet.margin(.medium)
            messageField.height == 40
            
            scrollViewTableView.top == messageField.bottom + Stylesheet.margin(.medium)
        }
        
        constrain(teamNameLabel, sendButton, tableView, scrollViewTableView, scrollViewCollectionView) { teamNameLabel, sendButton, tableView, scrollViewTableView, scrollViewCollectionView in
            teamNameLabel.centerY == sendButton.centerY
            teamNameLabel.leading == teamNameLabel.superview!.leading
            teamNameLabel.trailing == sendButton.leading
            
            sendButton.top == sendButton.superview!.top + Stylesheet.margin(.medium)
            sendButton.trailing == sendButton.superview!.trailing - Stylesheet.margin(.medium)
            
            tableView.top == tableView.superview!.top + Stylesheet.margin(.big)
            tableView.leading == tableView.superview!.leading
            tableView.trailing == tableView.superview!.trailing
            tableView.bottom == tableView.superview!.bottom
            tableView.height == 400
            tableView.width == 400
            
            scrollViewTableView.leading == scrollViewTableView.superview!.leading
            scrollViewTableView.trailing == scrollViewTableView.superview!.trailing
            scrollViewTableView.bottom == scrollViewCollectionView.top
        }
        
        constrain(scrollViewCollectionView, addButton) { scrollViewCollectionView, addButton in
            addButton.bottom == addButton.superview!.bottom - Stylesheet.margin(.medium)
            addButton.trailing == addButton.superview!.trailing - Stylesheet.margin(.medium)
            
            scrollViewCollectionView.bottom == scrollViewCollectionView.superview!.bottom
            scrollViewCollectionView.leading == scrollViewCollectionView.superview!.leading
            scrollViewCollectionView.trailing == addButton.leading - Stylesheet.margin(.medium)
            scrollViewCollectionView.height == 50
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
