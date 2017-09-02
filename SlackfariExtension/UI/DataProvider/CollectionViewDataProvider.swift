//
//  CollectionViewDataProvider.swift
//  Slackfari
//
//  Created by Alberto Moral on 02/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import AlamofireImage

protocol CollectionViewDataProviderDelegate: class {
    func didTapOnTeam(withToken token: String)
}

class CollectionViewDataProvider: NSObject {
    
    weak var delegate: CollectionViewDataProviderDelegate?
    
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
        guard let collectionViewItem = item as? CollectionViewItem else { return item }
        
        collectionViewItem.nameLabel?.stringValue = items[indexPath.item]["name"]!
        
        let imageURL = items[indexPath.item]["image"]!
        
        Alamofire.request(imageURL).responseImage { response in
            if let image = response.result.value {
                collectionViewItem.teamImageView.image = image
            }
        }
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let token = items[(indexPaths.first?.item)!]["token"]
        delegate?.didTapOnTeam(withToken: token!)
    }
}
