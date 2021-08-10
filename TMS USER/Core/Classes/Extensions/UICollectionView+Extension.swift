//
//  UICollectionView+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/15/21.
//

import UIKit

extension UICollectionView {
    func registerCell(identifier: String) {
        self.register(UINib.init(nibName: identifier, bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
    }
}

extension UICollectionViewCell {
    func setShadowCollectionViewCell() {
        self.layer.cornerRadius = 25.0
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false //<-
    }
}

extension UITableViewCell {
    func setShadowTableViewCell() {
        self.layer.cornerRadius = 25.0
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false //<-
    }
}
