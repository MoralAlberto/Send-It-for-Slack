//
//  SafariExtensionViewController+AddTeamView.swift
//  SlackfariExtension
//
//  Created by Alberto Moral on 20/09/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Foundation
import Cocoa
import Cartography

extension SafariExtensionViewController {
    
    private struct Constants {
        struct TeamView {
            static let minHeight: CGFloat = 140
            static let maxHeight: CGFloat = 140
            static let animationDuration: TimeInterval = 2
        }
    }
    
    @IBAction func addTeam(_ sender: NSButton) {
        view.addSubview(addTeamView)
        
        constrain(addTeamView, replace: constraintGroup) { addTeamView in
            addTeamView.leading == addTeamView.superview!.leading
            addTeamView.trailing == addTeamView.superview!.trailing
            addTeamView.bottom == addTeamView.superview!.bottom
            addTeamView.height == Constants.TeamView.minHeight
        }
        
        NSAnimationContext.runAnimationGroup({ context in
            constrain(addTeamView, replace: constraintGroup) { addTeamView in
                context.duration = Constants.TeamView.animationDuration
                context.allowsImplicitAnimation = true
                
                addTeamView.leading == addTeamView.superview!.leading
                addTeamView.trailing == addTeamView.superview!.trailing
                addTeamView.bottom == addTeamView.superview!.bottom
                addTeamView.height == Constants.TeamView.maxHeight
            }
        }, completionHandler: nil)
    }
}
