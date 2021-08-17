//
//  EmployeeTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    static let identifier = "EmployeeTableViewCell"
    
    @IBOutlet var imagePoster: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var descText: UILabel!
    @IBOutlet var positionText: UILabel!
    @IBOutlet var bgView: UIView!
    
    var item: CustomerItems? {
        didSet {
            setupValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        bgView.setRounded(rounded: 8)
        bgView.setShadowBoxView()
        
        imagePoster.setRounded(rounded: imagePoster.frame.width/2)
        imagePoster.contentMode = .scaleAspectFill
    }
    
    func setupValue() {
        titleText.text = item?.displayName ?? ""
        descText.text = "\(item?.fname ?? "") \(item?.lname ?? "")"
        positionText.text = "ตำแหน่ง : \(item?.typeUser?.typeName ?? "")"
        setImage(url: item?.avatar)
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.TMSImagePath.urlString)\(url ?? "")") else { return }
        imagePoster.kf.setImageDefault(with: urlImage)
    }
}
