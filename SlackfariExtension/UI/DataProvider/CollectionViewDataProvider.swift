//
//  CollectionViewDataProvider.swift
//  Slackfari
//
//  Created by Alberto Moral on 02/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa

class CollectionViewDataProvider: NSObject {
    
    fileprivate var items = [[String: String]]()
    private var collectionView: NSCollectionView
    
    init(collectionView: NSCollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func getTeam(at index: Int) -> [String: String]? {
        guard index <= items.count else { return nil }
        return items[index]
    }
    
    func set(items: [[String: String]]) {
        self.items = items
    }
}

extension CollectionViewDataProvider: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
        guard item is CollectionViewItem else { return item }        
        item.textField?.stringValue = items[indexPath.item]["name"]!
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let token = items[(indexPaths.first?.item)!]["token"]
        Swift.print("Token \(String(describing: token))")
    }
}
