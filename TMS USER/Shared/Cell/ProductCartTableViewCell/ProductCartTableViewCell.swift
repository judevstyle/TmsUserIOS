//
//  ProductCartTableViewCell.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import UIKit

class ProductCartTableViewCell: UITableViewCell {

    static let identifier = "ProductCartTableViewCell"
    @IBOutlet weak var orderCartView: UIView!
    
    @IBOutlet weak var imageThubnail: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descText: UILabel!
    
    @IBOutlet weak var priceText: UILabel!
    
    @IBOutlet weak var qytText: UILabel!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    @IBOutlet var removeCart: UIButton!
    
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
        
        orderCartView.setRounded(rounded: 8)
        imageThubnail.setRounded(rounded: 8)
        
        titleText.font = UIFont.PrimaryText(size: 12)
        descText.font = UIFont.PrimaryText(size: 10)
        
        priceText.font = UIFont.PrimaryText(size: 14)
        
        deleteButton.setRounded(rounded: deleteButton.frame.width/2)
        addButton.setRounded(rounded: addButton.frame.width/2)
    }
    @IBAction func DeleteQtyAction(_ sender: Any) {
        
        let number:Int? = Int(qytText.text ?? "")
        if var numberNew = number, numberNew > 0 {
            numberNew -= 1
            qytText.text = "\(numberNew)"
        }
    }
    
    @IBAction func AddQtyAction(_ sender: Any) {
        
        let number:Int? = Int(qytText.text ?? "")
        if var numberNew = number {
            numberNew += 1
            qytText.text = "\(numberNew)"
        }
    }
    
    @IBAction func removeAction(_ sender: Any) {
    }
}
