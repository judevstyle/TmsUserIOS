//
//  ProductDetailBottomSheetViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
import Combine

public protocol ProductDetailBottomSheetViewModelDelegate {
    func didUpdateOrderCart()
}

protocol ProductDetailBottomSheetProtocolInput {
    func setProductItems(items: ProductItems?)
    func setDelegate(delegate: ProductDetailBottomSheetViewModelDelegate)
    
    func didConfrimProduct(qty: String)
    
    func didAddQty(qty: String)
    func didDeleteQty(qty: String)
}

protocol ProductDetailBottomSheetProtocolOutput: class {
    var didUpdateQty: (() -> Void)? { get set }
    
    func getProducItems() -> ProductItems?
    func getQty() -> String
}

protocol ProductDetailBottomSheetProtocol: ProductDetailBottomSheetProtocolInput, ProductDetailBottomSheetProtocolOutput {
    var input: ProductDetailBottomSheetProtocolInput { get }
    var output: ProductDetailBottomSheetProtocolOutput { get }
}

class ProductDetailBottomSheetViewModel: ProductDetailBottomSheetProtocol, ProductDetailBottomSheetProtocolOutput {
    var input: ProductDetailBottomSheetProtocolInput { return self }
    var output: ProductDetailBottomSheetProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getFinishOrderCustomerUseCase: GetFinishOrderCustomerUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var productDetailBottomSheetViewController: ProductDetailBottomSheetViewController
    
    public var delegate: ProductDetailBottomSheetViewModelDelegate!
    
    init(
        productDetailBottomSheetViewController: ProductDetailBottomSheetViewController,
        getFinishOrderCustomerUseCase: GetFinishOrderCustomerUseCase = GetFinishOrderCustomerUseCaseImpl()
    ) {
        self.productDetailBottomSheetViewController = productDetailBottomSheetViewController
        self.getFinishOrderCustomerUseCase = getFinishOrderCustomerUseCase
    }
    
    // MARK - Data-binding OutPut
    var didUpdateQty: (() -> Void)?
    
    public var productItems: ProductItems?
    public var productQty: Int = 0
    
    func setProductItems(items: ProductItems?) {
        self.productItems = items
    }
    
    func getProducItems() -> ProductItems? {
        return self.productItems
    }
    
    func setDelegate(delegate: ProductDetailBottomSheetViewModelDelegate) {
        self.delegate = delegate
    }
    
    func didConfrimProduct(qty: String) {
        if let qty = Int(qty), let item = self.productItems, qty > 0 {
            OrderCartManager.sharedInstance.updateProductCart(item, qty: qty, completion: {
                self.delegate.didUpdateOrderCart()
                self.productDetailBottomSheetViewController.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func didAddQty(qty: String) {
        if let qty = Int(qty) {
            self.productQty = qty
            self.productQty += 1
            didUpdateQty?()
        }
    }
    
    func didDeleteQty(qty: String) {
        if let qty = Int(qty) {
            self.productQty = qty
            if self.productQty > 0 {
                self.productQty -= 1
            }
            didUpdateQty?()
        }
    }
    
    func getQty() -> String {
        return "\(self.productQty)"
    }
}

