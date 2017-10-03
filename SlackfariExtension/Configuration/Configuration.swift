/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import Foundation

class Configuration {
    
    let sharedInstance = Configuration()
    
    struct Screen {
        static let width: CGFloat = 300
        static let height: CGFloat = 200
    }
    struct TeamCollectionView {
        static let height: CGFloat = 50
    }
    struct MessageField {
        static let height: CGFloat = 40
    }
}
