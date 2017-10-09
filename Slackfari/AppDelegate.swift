//
//  AppDelegate.swift
//  Slackfari
//
//  Created by Alberto Moral on 15/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupNavigationButton()
        configureInitialViewController()
    }
    
    private func configureInitialViewController() {
        let vc = ViewController()
        popover.contentViewController = vc
        popover.appearance = NSAppearance(named: NSAppearanceNameAqua)
    }
}

