/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */

import Cocoa
import Alamofire
import AlamofireImage

protocol TeamCollectionViewAdapterDelegate: class {
    func didTapOnTeam(withToken token: String)
}

class TeamCollectionViewAdapter: NSObject {
    fileprivate static let numberOfSections = 1
    fileprivate static let itemId = "TeamCollectionViewItem"
    
    weak var delegate: TeamCollectionViewAdapterDelegate?
    
    fileprivate var items = [TeamModel]() {
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
    
    func getTeam(at index: Int) -> TeamModel? {
        guard index <= items.count else { return nil }
        return items[index]
    }
    
    func set(items: [TeamModel]) {
        self.items = items
    }
}

extension TeamCollectionViewAdapter: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return TeamCollectionViewAdapter.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: TeamCollectionViewAdapter.itemId, for: indexPath)
        guard let collectionViewItem = item as? TeamCollectionViewItem else { return item }
        
        let name = items[indexPath.item].name
        let icon = items[indexPath.item].imageIcon
        collectionViewItem.configure(name: name, avatarURL: icon)
        collectionViewItem.delegate = self
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        let token = items[(indexPaths.first?.item)!].token
        delegate?.didTapOnTeam(withToken: token)
    }
}

extension TeamCollectionViewAdapter: TeamCollectionViewItemDelegate {
    func didTapOnRemoveTeam(withName name: String) {
        UserDefaults.standard.removeTeam(withName: name) { [weak self] position in
            guard let strongSelf = self else { return }
            strongSelf.items.remove(at: position)
            if !strongSelf.items.isEmpty {
                let token = strongSelf.items.first?.token
                strongSelf.delegate?.didTapOnTeam(withToken: token!)
            } else {
                strongSelf.items = [TeamModel]()
            }
        }
    }
}
