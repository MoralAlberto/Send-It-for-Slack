//
//  BaseView.swift
//  SlackfariExtension
//
//  Created by Alberto Moral on 02/10/2017.
//  Copyright © 2017 Alberto Moral. All rights reserved.
//

import Cocoa

class BaseView: NSView {
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    func setup() {
        addSubviews()
        addConstraints()
    }
    
    func addSubviews() { }
    func addConstraints() { }
}
