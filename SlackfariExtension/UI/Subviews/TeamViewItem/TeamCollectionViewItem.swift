/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import Cocoa
import Cartography

protocol TeamCollectionViewItemDelegate: class {
    func didTapOnRemoveTeam(withName name: String)
}

class TeamCollectionViewItem: NSCollectionViewItem {
    weak var delegate: TeamCollectionViewItemDelegate?
    
    let teamCellView = TeamCellView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamCellView.delegate = self
        view.wantsLayer = true
        view.layer?.backgroundColor = Stylesheet.color(.white).cgColor
    }
    
    override func loadView() {
        view = teamCellView
    }
    
    func configure(name: String, avatarURL: String) {
        teamCellView.name = name
        teamCellView.setTeamAvatar(url: avatarURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamCellView.flushData()
    }
}

extension TeamCollectionViewItem: TeamCellViewDelegate {
    func didTapOnRemoveTeam(withName name: String) {
        delegate?.didTapOnRemoveTeam(withName: name)
    }
}
