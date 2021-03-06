/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */

import Cocoa
import Cartography

protocol SafariExtensionViewDelegate: class {
    func didTapOnSendMessage()
    func didTapOnAddTeam()
}

class SafariExtensionView: BaseView {
    
    private struct ViewConstraints {
        struct NotificationLabel {
            static let height: CGFloat = 20
        }
        struct SendButton {
            static let width: CGFloat = 60
        }
    }
    
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
        textField.font = Stylesheet.font(.normal)
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
    
    override func setup() {
        addSubviews()
        addConstraints()
    }
    
    override func addSubviews() {
        scrollViewTableView.documentView = tableView
        scrollViewCollectionView.documentView = collectionView
        
        [scrollViewTableView, scrollViewCollectionView, teamNameLabel, sendButton, addButton, messageField, notificationLabel].forEach(addSubview)
    }
    
    override func addConstraints() {
        constrain(teamNameLabel, messageField, scrollViewTableView, sendButton, notificationLabel) { teamNameLabel, messageField, scrollViewTableView, sendButton, notificationLabel in
            
            notificationLabel.top == teamNameLabel.bottom + Stylesheet.margin(.small)
            notificationLabel.leading == teamNameLabel.leading
            notificationLabel.trailing == teamNameLabel.trailing
            notificationLabel.height == ViewConstraints.NotificationLabel.height
            
            messageField.leading == messageField.superview!.leading + Stylesheet.margin(.small)
            messageField.trailing == messageField.superview!.trailing - Stylesheet.margin(.small)
            messageField.top == notificationLabel.bottom + Stylesheet.margin(.small)
            messageField.height == Configuration.MessageField.height
            
            scrollViewTableView.top == messageField.bottom + Stylesheet.margin(.medium)
        }
        
        constrain(teamNameLabel, sendButton, scrollViewTableView, scrollViewCollectionView) { teamNameLabel, sendButton, scrollViewTableView, scrollViewCollectionView in
            teamNameLabel.centerY == sendButton.centerY
            teamNameLabel.leading == teamNameLabel.superview!.leading + Stylesheet.margin(.medium)
            teamNameLabel.trailing == sendButton.leading
            
            sendButton.top == sendButton.superview!.top + Stylesheet.margin(.medium)
            sendButton.trailing == sendButton.superview!.trailing - Stylesheet.margin(.medium)
            sendButton.width == ViewConstraints.SendButton.width
            
            scrollViewTableView.width == Configuration.Screen.width
            scrollViewTableView.height == Configuration.Screen.height
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
