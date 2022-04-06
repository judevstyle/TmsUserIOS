//
//  MyRewardPointTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 2/4/2565 BE.
//

import UIKit

class MyRewardPointTableViewCell: UITableViewCell {
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleText: TextTitleCellBlack!
    @IBOutlet var descText: TextDescCellDarkGray!
    @IBOutlet var statusText: TextDescCellDarkGray!
    @IBOutlet var pointText: UILabel!
    @IBOutlet var dateText: TextDescCellDarkGray!
    
    
    static let identifier = "MyRewardPointTableViewCell"
    
    var item: RewardPointItem? {
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
        self.posterImage.setRounded(rounded: 8)
        self.pointText.font = .PrimaryMedium(size: 16)
        self.pointText.textColor = .Primary
    }
    
    func setupValue() {
        self.titleText.text = item?.collectibles?.clbTitle ?? ""
        self.descText.text = item?.collectibles?.clbDescript ?? ""
        
        if item?.status == "W" {
            self.statusText.text = "สถานะ: รอการจัดส่ง"
        } else if item?.status == "S" {
            self.statusText.text = "สถานะ: จัดส่งสำเร็จ"
        }
        
        self.pointText.text = "\(item?.rewardPoint ?? 0)"
        
        setImage(url: item?.collectibles?.clbImg)
        if let createDate = item?.createDate  {
            self.dateText.text = createDate.convertToDate()?.getFormattedDate(format: "dd/MM/yyyy HH:mm") ?? ""
        } else {
            self.dateText.text = ""
        }
        
        self.titleText.sizeToFit()
        self.dateText.sizeToFit()
        self.statusText.sizeToFit()
        self.pointText.sizeToFit()
        self.dateText.sizeToFit()
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(url ?? "")") else { return }
        posterImage.kf.setImageDefault(with: urlImage)
    }
}
