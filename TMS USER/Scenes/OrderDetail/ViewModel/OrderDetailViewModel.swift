//
//  OrderDetailViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import Foundation
import UIKit
import Combine

protocol OrderDetailProtocolInput {
    func getOrderDetail()
    func setUp(orderId: Int?, orderDetailType: OrderDetailType?)
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
    
    func didCreateOrder()
}

protocol OrderDetailProtocolOutput: class {
    var didGetOrderDetailSuccess: (() -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight(indexPath: IndexPath) -> CGFloat
    
    func getOrderDetailType() -> OrderDetailType?
    
    //Header
    func getHeightSectionView(section: Int) -> CGFloat
    func getHeaderViewCell(_ tableView: UITableView, section: Int) -> UIView?
    
    //OrderNo
    func getOrderNo() -> String
    //AllSum
    func getSumPrice() -> Int
    func getDiscountPrice() -> Int
    func getOverAllPrice() -> Int
}

protocol OrderDetailProtocol: OrderDetailProtocolInput, OrderDetailProtocolOutput {
    var input: OrderDetailProtocolInput { get }
    var output: OrderDetailProtocolOutput { get }
}

class OrderDetailViewModel: OrderDetailProtocol, OrderDetailProtocolOutput {
    var input: OrderDetailProtocolInput { return self }
    var output: OrderDetailProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getOrderDetailUseCase: GetOrderDetailUseCase
    private var putReOrderCustomerUseCase: PutReOrderCustomerUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: OrderDetailViewController
    
    public var orderDetailType: OrderDetailType? = .orderDetail
    
    init(
        vc: OrderDetailViewController,
        getOrderDetailUseCase: GetOrderDetailUseCase = GetOrderDetailUseCaseImpl(),
        putReOrderCustomerUseCase: PutReOrderCustomerUseCase = PutReOrderCustomerUseCaseImpl()
    ) {
        self.vc = vc
        self.getOrderDetailUseCase = getOrderDetailUseCase
        self.putReOrderCustomerUseCase = putReOrderCustomerUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetOrderDetailSuccess: (() -> Void)?
    
    public var orderDetailData: OrderDetailData?
    public var listOrderD: [OrderD]? = []
    public var listCustomer: [CustomerItems]? = []
    public var orderId: Int? = nil
    
    func setUp(orderId: Int?, orderDetailType: OrderDetailType?) {
        self.orderId = orderId
        self.orderDetailType = orderDetailType
    }
    
    func getOrderDetail() {
        guard let orderId = orderId else { return }
        self.vc.startLoding()
        self.getOrderDetailUseCase.execute(orderId: orderId).sink { completion in
            debugPrint("getOrderDetail \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            
            if let item = resp {
                self.orderDetailData = item
            }
            
            if let items = resp?.orderD {
                self.listOrderD = items
                debugPrint("listOrderD \(items)")
            }
            
            if let items = resp?.customer {
                self.listCustomer = [items]
            }
            
            self.didGetOrderDetailSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getNumberOfSections(in tableView: UITableView) -> Int {
        if self.orderDetailType == .orderDetail {
            return 2
        } else {
            return 1
        }
    }
    
    func getOrderDetailType() -> OrderDetailType? {
        return self.orderDetailType
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        if self.orderDetailType == .orderDetail {
            switch section {
            case 0:
                return self.listCustomer?.count ?? 0
            default:
                return self.listOrderD?.count ?? 0
            }
        } else {
            return self.listOrderD?.count ?? 0
        }

    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if self.orderDetailType == .orderDetail {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier, for: indexPath) as! EmployeeTableViewCell
                cell.selectionStyle = .none
                cell.item = listCustomer?[indexPath.item]
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
                cell.orderD = listOrderD?[indexPath.item]
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier, for: indexPath) as! ProductListTableViewCell
            cell.orderD = listOrderD?[indexPath.item]
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func getItemViewCellHeight(indexPath: IndexPath) -> CGFloat {
        
        if self.orderDetailType == .orderDetail {
            switch indexPath.section {
            case 0:
                return 83
            default:
                return 105
            }
        } else {
            return 105
        }
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        //        NavigationManager.instance.pushVC(to: .orderDetail)
    }
    
    func getHeightSectionView(section: Int) -> CGFloat {
        return 25
    }
    
    func getHeaderViewCell(_ tableView: UITableView, section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderLabelTableViewCell.identifier)
        if let header = header as? HeaderLabelTableViewCell {
            
            if self.orderDetailType == .orderDetail {
                switch section {
                case 0:
                    header.render(title: "จัดส่งโดย")
                default:
                    header.render(title: "รายการสินค้า")
                }
            } else {
                header.render(title: "รายการสินค้า")
            }
        }
        return header
    }
    
    func getOrderNo() -> String {
        return self.orderDetailData?.orderNo ?? ""
    }
    
    func getSumPrice() -> Int {
        var sumPrice: Int = 0
        
        self.listOrderD?.forEach({ item in
            if let qty = item.qty {
                sumPrice += (qty * (item.price ?? 0))
            }
        })
        return sumPrice
    }
    
    func getDiscountPrice() -> Int {
//        var discountPrice: Int = 0
//        self.listProductCart?.forEach({ item in
//            if let discount = item.productDiscount,
//               let newPrice = discount.newPrice,
//               let productPrice = item.productPrice,
//               let qty = item.productCartQty,
//               newPrice < productPrice {
//                let discount = (productPrice - newPrice)
//                discountPrice += (qty * discount)
//            }
//
//            if let promotions = item.promotion,
//               let qty = item.productCartQty,
//               let productPrice = item.productPrice {
//                for promotion in promotions {
//                    if qty >= promotion.qty ?? 0 {
//                        let discount = (productPrice - (promotion.itemPrice ?? 0))
//                        discountPrice += (qty * discount)
//                        break
//                    }
//                }
//            }
//
//        })
        return 0
    }
    
    func getOverAllPrice() -> Int {
        var overAllPrice: Int = 0
        self.listOrderD?.forEach({ item in
            if let qty = item.qty {
                overAllPrice += (qty * (item.price ?? 0))
            }
        })
        return overAllPrice
    }
}

extension OrderDetailViewModel {
    
    func didCreateOrder() {
        let objs = OrderCartManager.sharedInstance.getProductCart()
        if let objs = objs, objs.count > 0 {
            vc.showAlertComfirm(titleText: "คุณต้องการเปลี่ยนแปลง\nตะกร้าสินค้า ใช่หรือไม่ ?", messageText: "", dismissAction: {
            }, confirmAction: {
                OrderCartManager.sharedInstance.clearProductCart {
                    self.addOrderToProductCart()
                }
            })
        } else {
            addOrderToProductCart()
        }
    }
    
    func addOrderToProductCart() {
        putReOrderCustomer { items in
            items.enumerated().forEach({ (index, item) in
                if let itemProduct = item.product,
                   let qty = item.qty {
                    OrderCartManager.sharedInstance.addProductCart(itemProduct, qty: qty, completion: {
                        if index == (items.count - 1) {
                            NavigationManager.instance.pushVC(to: .productCart(),
                                                              presentation: .ModelNav(completion: {}, isFullScreen: true))
                        }
                    })
                }
            })
        }
    }
    
    func putReOrderCustomer(completion: @escaping ([ReOrderCustomer]) -> Void) {
        guard let orderId = self.orderId else { return }
        self.vc.startLoding()
        self.putReOrderCustomerUseCase.execute(orderId: orderId).sink { completion in
            debugPrint("GetReOrderCustomer \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                completion(items)
            }
        }.store(in: &self.anyCancellable)
    }
}
