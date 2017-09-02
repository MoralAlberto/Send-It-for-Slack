//
//  CollectionViewItem.swift
//  Slackfari
//
//  Created by Alberto Moral on 02/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
//        textField?.stringValue = "Team"
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
}
