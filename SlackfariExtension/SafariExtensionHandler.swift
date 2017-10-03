/**
 *  Slackfari
 *  Copyright (c) 2017 Alberto Moral
 *  Licensed under the MIT license, see LICENSE file
 */


import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        page.getPropertiesWithCompletionHandler { properties in
            guard let text = properties?.url else { return }
            SafariExtensionViewController.shared.url = text.absoluteString
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
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
