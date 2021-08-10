//
//  ProductCartViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
import Combine

protocol ProductCartProtocolInput {
    func getProductCart()
}

protocol ProductCartProtocolOutput: class {
    var didGetProductCartSuccess: (() -> Void)? { get set }
    var didGetProductCartError: (() -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfProductCart(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol ProductCartProtocol: ProductCartProtocolInput, ProductCartProtocolOutput {
    var input: ProductCartProtocolInput { get }
    var output: ProductCartProtocolOutput { get }
}

class ProductCartViewModel: ProductCartProtocol, ProductCartProtocolOutput {
    var input: ProductCartProtocolInput { return self }
    var output: ProductCartProtocolOutput { return self }
    
    // MARK: - UseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var productCartViewController: ProductCartViewController
    
    fileprivate var orderId: Int?
    fileprivate var listProductCart: [ProductItems]? = []

    init(
        productCartViewController: ProductCartViewController
    ) {
        self.productCartViewController = productCartViewController
    }
    
    // MARK - Data-binding OutPut
    var didGetProductCartSuccess: (() -> Void)?
    var didGetProductCartError: (() -> Void)?
    
    func getProductCart() {
        didGetProductCartSuccess?()
    }

    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getNumberOfProductCart(_ tableView: UITableView, section: Int) -> Int {
        guard let count = listProductCart?.count, count != 0 else { return 5 }
        return count
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCartTableViewCell.identifier, for: indexPath) as! ProductCartTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 137
    }
}
