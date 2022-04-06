//
//  AcceptDialogView.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 6/4/2565 BE.
//

import UIKit

public struct AcceptDialogMsg {
    public var title: String = ""
    public var pointBalance: String = ""
    public var usePoint: String = ""
    
    init(title: String,
         pointBalance: String,
         usePoint: String) {
        self.title = title
        self.pointBalance = pointBalance
        self.usePoint = usePoint
    }
}

class AcceptDialogView: UIView {
    
    let nibName = "AcceptDialogView"
    var contentView:UIView?
    
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var titleText: TextBold24!
    @IBOutlet var pointBalanceText: Text14!
    @IBOutlet var usePointText: Text16!
    
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var cancalButton: UIButton!
    
    public var delegate: DialogViewDelegate?
    public var msg: AcceptDialogMsg?
    
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
        cancalButton.setRounded(rounded: 8)
        cancalButton.setBorder(width: 1, color: .Primary)
        cancalButton.setTitle("ยกเลิก", for: .normal)
        cancalButton.titleLabel?.font = .PrimaryMedium(size: 16)
        cancalButton.setTitleColor(.Primary, for: .normal)
        cancalButton.backgroundColor = .white
    }
    
    func setGradientColor() {
        acceptButton.setRounded(rounded: 8)
        acceptButton.addGradientButton(colors: [UIColor.Primary.cgColor, UIColor.PrimaryAlpha.cgColor],
                                       locations: [0.5, 1.0],
                                       direction: .leftToRight,
                                       cornerRadius: 8)
        acceptButton.setTitle("ยืนยัน", for: .normal)
        acceptButton.titleLabel?.font = .PrimaryMedium(size: 16)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.titleLabel?.textColor = .white
        acceptButton.layoutIfNeeded()
    }
    
    func setMessage(msg: AcceptDialogMsg?) {
        self.titleText.text = msg?.title ?? ""
        self.pointBalanceText.text = msg?.pointBalance ?? ""
        self.usePointText.text = msg?.usePoint ?? ""
    }
    
    @IBAction func handleAcceptButton(_ sender: Any) {
        self.delegate?.didAccept()
    }
    
    @IBAction func handleCancalButton(_ sender: Any) {
        self.delegate?.didCancal()
    }
}
