//
//  Image1x1CollectionViewCell.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/15/21.
//

import UIKit

protocol Image1x1CollectionViewCellDelegate {
    func didDeleteAction(index: Int)
}

class Image1x1CollectionViewCell: UICollectionViewCell {

    static let identifier = "Image1x1CollectionViewCell"
    
    public var delegate: Image1x1CollectionViewCellDelegate?
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    public var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        bgView.setRounded(rounded: 8)
        imageView.setRounded(rounded: 8)
        deleteButton.setImage(UIImage.init(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteButton.imageView?.tintColor = UIColor.white
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        deleteButton.setRounded(rounded: deleteButton.frame.width/2)
        deleteButton.backgroundColor = UIColor.blackAlpha(alpha: 0.5)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.didDeleteAction(index: index ?? 0)
    }
    
}
