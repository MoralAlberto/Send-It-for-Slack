//
//  ViewController.swift
//  Slackfari
//
//  Created by Alberto Moral on 15/08/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Cocoa
import RxSwift
import SlackWebAPIKit


class ViewController: NSViewController {
    
    var postUserMessageUseCase: FindUserAndPostMessageUseCase?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.sharedInstance.set(token: "xoxp-220728744260-221560162310-226472479939-023594ef326c368b601646bec84b64b0")
        postUserMessageUseCase = FindUserAndPostMessageUseCase()
        postUserMessageUseCase?.execute(text: "Test", user: "alberto")
            .subscribe(onNext: { (isSent) in
                print("onNext \(isSent)")
            }, onError: { (error) in
                print("onError \(error)")
            }, onCompleted: {
                print("onComplete")
            }).addDisposableTo(disposeBag)
        
    }
}

