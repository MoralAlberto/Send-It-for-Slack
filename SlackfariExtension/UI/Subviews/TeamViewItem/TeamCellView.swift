import Foundation
import AppKit
import Cartography
import Alamofire
import AlamofireImage

protocol TeamCellViewDelegate: class {
    func didTapOnRemoveTeam(withName name: String)
}

class TeamCellView: NSView {
    weak var delegate: TeamCellViewDelegate?
    
    let imageView: NSImageView = NSImageView()
    
    let nameField: NSTextField = {
        let textField = NSTextField()
        textField.backgroundColor = Stylesheet.color(.white)
        textField.isBordered = false
        textField.isEditable = false
        textField.font = NSFont.systemFont(ofSize: 10)
        textField.alignment = .center
        return textField
    }()
    
    lazy var deleteTeam: NSTextField = {        
        let textField = NSTextField()
        textField.backgroundColor = Stylesheet.color(.mainLightGray)
        textField.isBordered = false
        textField.isEditable = false
        textField.font = NSFont.systemFont(ofSize: 6)
        textField.alignment = .center
        textField.stringValue = "x"
        
        let gesture = NSClickGestureRecognizer(target: self, action: #selector(delete))
        gesture.numberOfClicksRequired = 1
        textField.addGestureRecognizer(gesture)
        
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
        [imageView, nameField, deleteTeam].forEach(addSubview)

        constrain(imageView) { imageView in
            imageView.leading == imageView.superview!.leading
            imageView.trailing == imageView.superview!.trailing
            imageView.bottom == imageView.superview!.bottom
            imageView.top == imageView.superview!.top
        }
        
        constrain(nameField, deleteTeam) { nameField, deleteTeam in
            nameField.leading == nameField.superview!.leading
            nameField.trailing == nameField.superview!.trailing
            nameField.bottom == nameField.superview!.bottom
            
            deleteTeam.top == deleteTeam.superview!.top
            deleteTeam.trailing == deleteTeam.superview!.trailing
        }
    }
    
    func delete() {
        guard let name = name else { return }
        delegate?.didTapOnRemoveTeam(withName: name)
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
