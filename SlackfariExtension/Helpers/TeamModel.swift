/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */

import Foundation

class TeamModel: NSObject, NSCoding {
    private struct Keys {
        static let name = "name"
        static let token = "token"
        static let imageIcon = "imageIcon"
    }
    
    var name: String
    var token: String
    var imageIcon: String
    
    required convenience init(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.name) as? String,
            let token = aDecoder.decodeObject(forKey: Keys.token) as? String,
            let imageIcon = aDecoder.decodeObject(forKey: Keys.imageIcon) as? String else {
                self.init(name: "", token: "", imageIcon: "")
                return
        }
        self.init(name: name, token: token, imageIcon: imageIcon)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name)
        aCoder.encode(token, forKey: Keys.token)
        aCoder.encode(imageIcon, forKey: Keys.imageIcon)
    }
    
    init(name: String, token: String, imageIcon: String) {
        self.name = name
        self.token = token
        self.imageIcon = imageIcon
        super.init()
    }
}
