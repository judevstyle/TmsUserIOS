//
//  SuccessDialogView.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import UIKit

public struct SuccessDialogMsg {
    public var title: String = ""
    
    init(title: String) {
        self.title = title
    }
}

class SuccessDialogView: UIView {
    
    let nibName = "SuccessDialogView"
    var contentView:UIView?
    
    @IBOutlet var logoImage: UIImageView!
    
    @IBOutlet var titleText: TextBold24!
    @IBOutlet var closeButton: UIButton!
    
    
    public var delegate: DialogViewDelegate?
    public var msg: SuccessDialogMsg?
    
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
        closeButton.setRounded(rounded: 8)
        closeButton.setBorder(width: 1, color: .Primary)
        closeButton.backgroundColor = .white
        closeButton.setTitle("ปิด", for: .normal)
        closeButton.titleLabel?.font = .PrimaryMedium(size: 16)
        closeButton.setTitleColor(.Primary, for: .normal)
        closeButton.titleLabel?.textColor = .Primary
    }

    func setMessage(msg: SuccessDialogMsg?) {
        self.titleText.text = msg?.title ?? ""
    }
    
    @IBAction func handleCloseButton(_ sender: Any) {
        delegate?.didClose()
    }
    
}
