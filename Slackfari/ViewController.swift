//
//  ViewController.swift
//  Slackfari
//
//  Created by Alberto Moral on 15/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var mainView: HomeView { return self.view as! HomeView }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
    }
    
    override func loadView() {
        view = HomeView()
    }
}

extension ViewController: HomeViewDelegate {
    func didTapOnQuit() {
        NSApp.terminate(self)
    }
}
