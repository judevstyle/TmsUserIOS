//
//  UITableView+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/13/21.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell(identifier: String) {
        self.register(UINib.init(nibName: identifier, bundle: Bundle.main), forCellReuseIdentifier: identifier)
    }
}
