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
    
    func didConfirmOrderCart()
}

protocol ProductCartProtocolOutput: class {
    var didGetProductCartSuccess: (() -> Void)? { get set }
    var didGetProductCartError: (() -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfProductCart(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
    //AllSum
    func getSumPrice() -> Int
    func getDiscountPrice() -> Int
    func getOverAllPrice() -> Int
}

protocol ProductCartProtocol: ProductCartProtocolInput, ProductCartProtocolOutput {
    var input: ProductCartProtocolInput { get }
    var output: ProductCartProtocolOutput { get }
}

class ProductCartViewModel: ProductCartProtocol, ProductCartProtocolOutput {
    
    var input: ProductCartProtocolInput { return self }
    var output: ProductCartProtocolOutput { return self }
    
    // MARK: - UseCase
    private var postCreateOrderByUserUseCase: PostCreateOrderByUserUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var productCartViewController: ProductCartViewController
    
    fileprivate var orderId: Int?
    fileprivate var listProductCart: [ProductItems]? = []

    init(
        productCartViewController: ProductCartViewController,
        postCreateOrderByUserUseCase: PostCreateOrderByUserUseCase = PostCreateOrderByUserUseCaseImpl()
    ) {
        self.productCartViewController = productCartViewController
        self.postCreateOrderByUserUseCase = postCreateOrderByUserUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetProductCartSuccess: (() -> Void)?
    var didGetProductCartError: (() -> Void)?
    
    func getProductCart() {
        let objs = OrderCartManager.sharedInstance.getProductCart()
        listProductCart?.removeAll()
        if let productCart = objs, productCart.count != 0 {
            productCart.forEach({
                item in
                if let item = item {
                    listProductCart?.append(item)
                }
            })
            didGetProductCartSuccess?()
        } else {
            didGetProductCartSuccess?()
        }
    }

    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getNumberOfProductCart(_ tableView: UITableView, section: Int) -> Int {
        guard let count = listProductCart?.count, count != 0 else { return 0 }
        
        return count
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCartTableViewCell.identifier, for: indexPath) as! ProductCartTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.itemsProduct = listProductCart?[indexPath.item]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 137
    }
    
    func getSumPrice() -> Int {
        var sumPrice: Int = 0
        
        self.listProductCart?.forEach({ item in
            if let qty = item.productCartQty {
                sumPrice += (qty * (item.productPrice ?? 0))
            }
        })
        return sumPrice
    }
    
    func getDiscountPrice() -> Int {
        var discountPrice: Int = 0
        self.listProductCart?.forEach({ item in
            if let discount = item.productDiscount,
               let newPrice = discount.newPrice,
               let productPrice = item.productPrice,
               let qty = item.productCartQty,
               newPrice < productPrice {
                let discount = (productPrice - newPrice)
                discountPrice += (qty * discount)
            }
        })
        return discountPrice
    }
    
    func getOverAllPrice() -> Int {
        var overAllPrice: Int = 0
        self.listProductCart?.forEach({ item in
            if let qty = item.productCartQty {
                if let discount = item.productDiscount {
                    overAllPrice += (qty * (discount.newPrice ?? 0))
                } else {
                    overAllPrice += (qty * (item.productPrice ?? 0))
                }
            }
        })
        return overAllPrice
    }
    
    func didConfirmOrderCart() {
        self.productCartViewController.showAlertComfirm(titleText: "คุณต้องการยืนยันคำสั่งซื้อหรือไม่ ?", messageText: "", dismissAction: {
        }, confirmAction: {
            self.postCreateOrderByUser()
        })
    }
    
    func postCreateOrderByUser() {
        let request = getRequestModel()
        self.productCartViewController.startLoding()
        self.postCreateOrderByUserUseCase.execute(request: request).sink { completion in
            debugPrint("postCreateOrderByUser \(completion)")
            self.productCartViewController.stopLoding()
            switch completion {
            case .finished:
                break
            case .failure(_):
                ToastManager.shared.toastCallAPI(title: "postCreateOrderByUser failure")
                break
            }

        } receiveValue: { resp in
            if resp?.success == true {
                ToastManager.shared.toastCallAPI(title: "postCreateOrderByUser finished")
                OrderCartManager.sharedInstance.clearProductCart {
                    self.productCartViewController.dismiss(animated: true, completion: nil)
                }
            }
        }.store(in: &self.anyCancellable)
    }
    
    private func getRequestModel() -> PostCreateOrderByUserRequest {
        var request: PostCreateOrderByUserRequest = PostCreateOrderByUserRequest()
        request.orderShipingStatus = "N"
        request.note = ""
        var listOrderD: [OrderD] = []
        self.listProductCart?.forEach({ item in
            var orderD: OrderD = OrderD()
            orderD.productId = item.productId
            // Price and Discount
            if let discount = item.productDiscount {
                orderD.price = discount.newPrice
                orderD.discountState = true
            } else {
                orderD.price = item.productPrice
                orderD.discountState = false
            }
            orderD.qty = item.productCartQty
            
            listOrderD.append(orderD)
        })
        
        request.orderD = listOrderD
        
        return request
    }
}


extension ProductCartViewModel: ProductCartTableViewCellDelegate {
    func didUpdateQty() {
        self.getProductCart()
    }
    
    func didRemoveProduct(item: ProductItems?) {
        productCartViewController.showAlertComfirm(titleText: "ต้องการลบสินค้า ใช่หรือไม่ ?", messageText: "", dismissAction: {
        }, confirmAction: {
            OrderCartManager.sharedInstance.removeItemProductCart(item: item, completion: {
                self.getProductCart()
            })
        })
    }
}
