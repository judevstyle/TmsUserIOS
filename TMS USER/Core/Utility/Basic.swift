//
//  Basic.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 30/3/2565 BE.
//

import Foundation
import UIKit
import CoreMedia

public extension UITableView {
    func register(nibCellClassName: String) {
        let nib = UINib(nibName: nibCellClassName, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: nibCellClassName)
    }
    
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}

/**
 UICollectionView.register(nibCellClassName:String)
 
 Shorthand method to register the class as a UICollectionViewCell. (Reuse Id is exact as className itself).
 */
public extension UICollectionView {
    func register(headerNibClassName: String) {
        let nib = UINib(nibName: headerNibClassName, bundle: .main)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNibClassName)
    }
    
    func register(footerNibClassName: String) {
        let nib = UINib(nibName: footerNibClassName, bundle: .main)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerNibClassName)
    }
    
    func register(nibCellClassName: String) {
        let nib = UINib(nibName: nibCellClassName, bundle: .main)
        self.register(nib, forCellWithReuseIdentifier: nibCellClassName)
    }
    
    func isIndexPathExists(_ indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }
    
}
