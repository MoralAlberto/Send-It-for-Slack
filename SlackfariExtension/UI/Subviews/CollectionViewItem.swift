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
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var teamImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        nameLabel.wantsLayer = true
        nameLabel.backgroundColor = Stylesheet.color(.mainLightGray)
        view.layer?.backgroundColor = Stylesheet.color(.mainLightGray).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.stringValue = ""
        teamImageView.image = nil
    }
}
