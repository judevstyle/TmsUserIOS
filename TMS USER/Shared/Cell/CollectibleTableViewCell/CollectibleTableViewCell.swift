//
//  CollectibleTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 5/4/2565 BE.
//

import UIKit

public protocol CollectibleTableViewCellDelegate {
    func didTapExchange(_ item: CollectibleItems?)
}

class CollectibleTableViewCell: UITableViewCell {
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleText: TextTitleCellBlack!
    @IBOutlet var descText: TextDescCellDarkGray!
    @IBOutlet var dateExchangeText: TextDescCellDarkGray!
    @IBOutlet var balanceText: TextDescCellDarkGray!
    @IBOutlet var pointText: UILabel!
    
    @IBOutlet var btnExchange: ButtonExchangeCollectible!
    
    static let identifier = "CollectibleTableViewCell"
    
    public var delegate: CollectibleTableViewCellDelegate?
    
    var item: CollectibleItems? {
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
    }
    
    func setupUI() {
        self.posterImage.setRounded(rounded: 8)
        self.pointText.font = .PrimaryMedium(size: 16)
        self.pointText.textColor = .Primary
    }
    
    func setupValue() {
        self.titleText.text = item?.clbTitle ?? ""
        self.descText.text = item?.clbDescript ?? ""
        
        self.pointText.text = "\(item?.rewardPoint ?? 0)"
        self.balanceText.text = "จำนวนคงเหลือ \(item?.qty ?? 0)"
        setImage(url: item?.clbImg)
        
        let startDate = item?.campaignStartDate?.convertToDate(.yyyyMMdd)?.getFormattedDate(format: "dd/MM/yyyy") ?? ""
        let endDate = item?.campaignEndDate?.convertToDate(.yyyyMMdd)?.getFormattedDate(format: "dd/MM/yyyy") ?? ""
        self.dateExchangeText.text = "ระยะเวลาการแลก \(startDate) to \(endDate)"
        
        
        self.titleText.sizeToFit()
        self.descText.sizeToFit()
        self.pointText.sizeToFit()
        self.balanceText.sizeToFit()
        self.dateExchangeText.sizeToFit()
    }
    
    private func setImage(url: String?) {
        guard let urlImage = URL(string: "\(DomainNameConfig.imagePath.urlString)\(url ?? "")") else { return }
        posterImage.kf.setImageDefault(with: urlImage)
    }
    
    @IBAction func handleExchange(_ sender: Any) {
        self.delegate?.didTapExchange(item)
    }
}
