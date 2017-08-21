//
//  SafariExtensionView.swift
//  Slackfari
//
//  Created by Alberto Moral on 21/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa
import Cartography

class SafariExtensionView: NSView {
    private struct Constrains {
        struct TableView {
            static let height: CGFloat = 135
        }
    }
    
    var tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.rowSizeStyle = .large
        tableView.backgroundColor = NSColor.clear
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    private func setupView() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func addConstraints() {
        constrain(tableView) { tableView in
            tableView.leading == tableView.superview!.leading
            tableView.trailing == tableView.superview!.trailing
            tableView.height == Constrains.TableView.height
        }
    }
}
