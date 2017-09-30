//
//  Stylesheet.swift
//  Slackfari
//
//  Created by Alberto Moral on 02/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

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
    case light
    case bold
    case italic
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
        case .light:
            return NSFont(name: "HelveticaNeue-Light", size: 20)!
        case .bold:
            return NSFont(name: "HelveticaNeue-Bold", size: 20)!
        case .italic:
            return NSFont(name: "HelveticaNeue-Italic", size: 20)!
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
