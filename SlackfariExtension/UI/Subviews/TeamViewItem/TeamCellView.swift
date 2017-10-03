import Cocoa
import Cartography
import Alamofire
import AlamofireImage

protocol TeamCellViewDelegate: class {
    func didTapOnRemoveTeam(withName name: String)
}

class TeamCellView: BaseView {
    weak var delegate: TeamCellViewDelegate?
    
    fileprivate let imageView: NSImageView = NSImageView()
    
    fileprivate let nameField: NSTextField = {
        let textField = NSTextField()
        textField.backgroundColor = Stylesheet.color(.white)
        textField.maximumNumberOfLines = 1
        textField.isBordered = false
        textField.isEditable = false
        textField.font = Stylesheet.font(.normal)
        textField.alignment = .center
        return textField
    }()
    
    lazy var deleteTeam: NSTextField = {        
        let textField = NSTextField()
        textField.backgroundColor = Stylesheet.color(.mainLightGray)
        textField.isBordered = false
        textField.isEditable = false
        textField.font = Stylesheet.font(.small)
        textField.alignment = .center
        textField.stringValue = "x"
        
        let gesture = NSClickGestureRecognizer(target: self, action: #selector(delete))
        gesture.numberOfClicksRequired = 1
        textField.addGestureRecognizer(gesture)
        
        return textField
    }()
    
    override func addSubviews() {
        [imageView, nameField, deleteTeam].forEach(addSubview)
    }
    
    override func addConstraints() {
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
    
    func flushData() {
        nameField.stringValue = ""
        imageView.image = nil
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
