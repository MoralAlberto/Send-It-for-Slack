//
//  Configuration.swift
//  SlackfariExtension
//
//  Created by Alberto Moral on 29/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

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
//    struct Teams {
//        static let value = "teams"
//    }
}
