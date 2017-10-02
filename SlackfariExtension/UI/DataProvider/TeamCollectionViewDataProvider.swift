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

protocol TeamCollectionViewDataProviderDelegate: class {
    func didTapOnTeam(withToken token: String)
}

class TeamCollectionViewDataProvider: NSObject {
    static let numberOfSections = 1
    static let itemId = "TeamCollectionViewItem"
    
    weak var delegate: TeamCollectionViewDataProviderDelegate?
    
    fileprivate var items = [[String: String]]() {
        didSet {
            collectionView.reloadData()
        }
    }
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

extension TeamCollectionViewDataProvider: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return TeamCollectionViewDataProvider.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: TeamCollectionViewDataProvider.itemId, for: indexPath)
        guard let collectionViewItem = item as? TeamCollectionViewItem else { return item }
        
        collectionViewItem.teamCellView.nameField.stringValue = items[indexPath.item]["name"]!
        collectionViewItem.delegate = self
        
        let imageURL = items[indexPath.item]["image"]!
        
        Alamofire.request(imageURL).responseImage { response in
            if let image = response.result.value {
                collectionViewItem.teamCellView.imageView.image = image
            }
        }
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let token = items[(indexPaths.first?.item)!]["token"]
        delegate?.didTapOnTeam(withToken: token!)
    }
}

extension TeamCollectionViewDataProvider: TeamCollectionViewItemDelegate {
    func didTapOnRemoveTeam(withName name: String) {
        UserDefaults.standard.removeTeam(withName: name) { [weak self] position  in
            guard let strongSelf = self else { return }
            strongSelf.items.remove(at: position)
            if strongSelf.items.count > 0 {
                let token = strongSelf.items.first?["token"]
                strongSelf.delegate?.didTapOnTeam(withToken: token!)
            } else {
                strongSelf.items = [[String: String]]()
            }
        }
    }
}
