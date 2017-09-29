import Foundation
import AppKit
import Cartography
import Alamofire
import AlamofireImage

class TeamCellView: NSView {
    let imageView: NSImageView = NSImageView()
    
    let nameField: NSTextField = {
        let textField = NSTextField()
        textField.backgroundColor = Stylesheet.color(.white)
        textField.isBordered = false
        textField.isEditable = false
        textField.alignment = .center
        return textField
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    func setup() {
        [imageView, nameField].forEach(addSubview)

        constrain(imageView) { imageView in
            imageView.leading == imageView.superview!.leading
            imageView.trailing == imageView.superview!.trailing
            imageView.bottom == imageView.superview!.bottom
            imageView.top == imageView.superview!.top
        }
        
        constrain(nameField) { nameField in
            nameField.leading == nameField.superview!.leading
            nameField.trailing == nameField.superview!.trailing
            nameField.bottom == nameField.superview!.bottom
        }
    }
}

extension TeamCellView {
    var name: String? {
        get {
            return nameField.stringValue
        }
        set(newValue) {
            nameField.stringValue = newValue ?? ""
        }
    }
    
    func setTeamAvatar(url: String) {
        Alamofire.request(url).responseImage { [weak self] response in
            guard let strongSelf = self else { return }
            if let image = response.result.value {
                strongSelf.imageView.image = image
            }
        }
    }
}
