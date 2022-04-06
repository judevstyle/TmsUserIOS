//
//  ErrorDialogView.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 6/4/2565 BE.
//

import UIKit

public struct ErrorDialogMsg {
    public var title: String = ""
    
    init(title: String) {
        self.title = title
    }
}

class ErrorDialogView: UIView {
    
    let nibName = "ErrorDialogView"
    var contentView:UIView?
    
    @IBOutlet var logoImage: UIImageView!
    
    @IBOutlet var titleText: TextBold24!
    @IBOutlet var closeButton: UIButton!
    
    
    public var delegate: DialogViewDelegate?
    public var msg: ErrorDialogMsg?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setupUI() {
        titleText.textColor = .white
        logoImage.image = UIImage(named: "ic_sad")?.withRenderingMode(.alwaysTemplate)
        logoImage.tintColor = .white
        
        closeButton.setRounded(rounded: 8)
        closeButton.backgroundColor = .white
        closeButton.setTitle("ปิด", for: .normal)
        closeButton.titleLabel?.font = .PrimaryMedium(size: 16)
        closeButton.setTitleColor(.red, for: .normal)
        closeButton.titleLabel?.textColor = .red
    }

    func setMessage(msg: ErrorDialogMsg?) {
        self.titleText.text = msg?.title ?? ""
    }
    
    @IBAction func handleCloseButton(_ sender: Any) {
        delegate?.didClose()
    }
    
}
