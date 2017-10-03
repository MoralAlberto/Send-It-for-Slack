/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import Cocoa
import Alamofire
import AlamofireImage

protocol TeamCollectionViewDataProviderDelegate: class {
    func didTapOnTeam(withToken token: String)
}

class TeamCollectionViewDataProvider: NSObject {
    fileprivate static let numberOfSections = 1
    fileprivate static let itemId = "TeamCollectionViewItem"
    
    weak var delegate: TeamCollectionViewDataProviderDelegate?
    
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

extension TeamCollectionViewDataProvider: TeamCollectionViewItemDelegate {
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
