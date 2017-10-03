/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import Foundation
import Cocoa

enum Color {
    case mainGray
    case mainLightGray
    case mainBlue
    case white
    case black
    case clear
}

enum Font {
    case small
    case normal
    case big
}

enum Margin {
    case smallest
    case small
    case medium
    case big
}

protocol Stylesheetable {
    static func font(_ font: Font) -> NSFont
    static func color(_ color: Color) -> NSColor
    static func margin(_ font: Margin) -> CGFloat
}

struct Stylesheet: Stylesheetable {
    static func font(_ font: Font) -> NSFont {
        switch font {
        case .small:
            return NSFont.systemFont(ofSize: 6)
        case .normal:
            return NSFont.systemFont(ofSize: 10)
        case .big:
            return NSFont.systemFont(ofSize: 20)
        }
    }
    
    static func color(_ color: Color) -> NSColor {
        switch color {
        case .mainGray:
            return NSColor(red: 144/255.0, green: 146/255.0, blue: 165/255.0, alpha: 1.0)
        case .mainLightGray:
            return NSColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
        case .mainBlue:
            return NSColor(red: 49/255.0, green: 165/255.0, blue: 236/255.0, alpha: 1.0)
        case .white:
            return NSColor.white
        case .black:
            return NSColor.black
        case .clear:
            return NSColor.clear
        }
    }
    
    static func margin(_ font: Margin) -> CGFloat {
        switch font {
        case .smallest:
            return 1
        case .small:
            return 4
        case .medium:
            return 8
        case .big:
            return 20
        }
    }
}
