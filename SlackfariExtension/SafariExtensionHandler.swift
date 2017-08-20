//
//  SafariExtensionHandler.swift
//  SafariExtension
//
//  Created by Alberto Moral on 15/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        page.getPropertiesWithCompletionHandler { properties in
            guard let text = properties?.url else {
                return
            }
            print("URL \(text.absoluteString)")
            SafariExtensionViewController.shared.url = text.absoluteString
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        NSLog("The extension's toolbar item was clicked")
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    override func popoverWillShow(in window: SFSafariWindow) {
        window.getActiveTab { (tab: SFSafariTab?) in
            tab?.getActivePage(completionHandler: { (page: SFSafariPage?) in
                page?.dispatchMessageToScript(withName: "message", userInfo: [:])
            })
        }
    }
    
}
