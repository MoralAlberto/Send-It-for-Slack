//
//  AppDelegate+Popover.swift
//  Slackfari
//
//  Created by Alberto Moral on 07/10/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Cocoa

extension AppDelegate {
    func showPopover(sender: AnyObject?) {
        clickNavigationButton()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func setupNavigationButton() {
        if let button = statusItem.button {
            let image = NSImage(named: "icon")
            image?.size = NSSize(width: 16, height: 16)
            button.image = image
            button.target = self
            button.action = #selector(togglePopover)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    func clickNavigationButton() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
}
