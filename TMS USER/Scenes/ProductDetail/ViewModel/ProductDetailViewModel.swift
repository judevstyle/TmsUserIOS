//
//  ProductDetailViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 9/30/21.
//

import Foundation
import UIKit
import Combine

public protocol ProductDetailViewModelDelegate {
    func didUpdateOrderCart()
}

protocol ProductDetailProtocolInput {
    func setProductItems(items: ProductItems?)
    func getProductDetail()
    func setDelegate(delegate: ProductDetailViewModelDelegate)
    
    func didConfrimProduct(qty: String)
    
    func didAddQty(qty: String)
    func didDeleteQty(qty: String)
}

protocol ProductDetailProtocolOutput: class {
    var didUpdateQty: (() -> Void)? { get set }
    var didGetProductDetailSuccess: (() -> Void)? { get set }
    
    func getProducItems() -> ProductItems?
    func getQty() -> String
}

protocol ProductDetailProtocol: ProductDetailProtocolInput, ProductDetailProtocolOutput {
    var input: ProductDetailProtocolInput { get }
    var output: ProductDetailProtocolOutput { get }
}

class ProductDetailViewModel: ProductDetailProtocol, ProductDetailProtocolOutput {
    var input: ProductDetailProtocolInput { return self }
    var output: ProductDetailProtocolOutput { return self }
    
    // MARK: - UseCase
    private var orderRepository: OrderRepository
    private var getProductDescForUserUseCase: GetProductDescForUserUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var productDetailViewController: ProductDetailViewController
    
    public var delegate: ProductDetailViewModelDelegate!
    
    init(
        productDetailViewController: ProductDetailViewController,
        orderRepository: OrderRepository = OrderRepositoryImpl(),
        getProductDescForUserUseCase: GetProductDescForUserUseCase = GetProductDescForUserUseCaseImpl()
    ) {
        self.productDetailViewController = productDetailViewController
        self.orderRepository = orderRepository
        self.getProductDescForUserUseCase = getProductDescForUserUseCase
    }
    
    // MARK - Data-binding OutPut
    var didUpdateQty: (() -> Void)?
    var didGetProductDetailSuccess: (() -> Void)?
    
    public var productItems: ProductItems?
    public var productQty: Int = 0
    
    func setProductItems(items: ProductItems?) {
        self.productItems = items
    }
    
    func getProductDetail() {
        guard let productId = self.productItems?.productId else { return }
        self.getProductDescForUserUseCase.execute(productId: productId).sink { completion in
            debugPrint("getProductDescForUserUseCase \(completion)")
            self.productDetailViewController.stopLoding()
        } receiveValue: { resp in
            self.productItems = resp
            self.didGetProductDetailSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getProducItems() -> ProductItems? {
        return self.productItems
    }
    
    func setDelegate(delegate: ProductDetailViewModelDelegate) {
        self.delegate = delegate
    }
    
    func didConfrimProduct(qty: String) {
        if let qty = Int(qty), let item = self.productItems, qty > 0 {
            OrderCartManager.sharedInstance.updateProductCart(item, qty: qty, completion: {
                self.delegate.didUpdateOrderCart()
                self.productDetailViewController.dismiss(animated: true, completion: nil)
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

