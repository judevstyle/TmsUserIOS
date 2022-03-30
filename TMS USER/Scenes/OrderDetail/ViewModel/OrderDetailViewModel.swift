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
    func setOrderId(orderId: Int?)
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
    
    
    func didCreateOrder()
}

protocol OrderDetailProtocolOutput: class {
    var didGetOrderDetailSuccess: (() -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight(indexPath: IndexPath) -> CGFloat
    
    //Header
    func getHeightSectionView(section: Int) -> CGFloat
    func getHeaderViewCell(_ tableView: UITableView, section: Int) -> UIView?
    
    //OrderNo
    func getOrderNo() -> String
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
    private var getReOrderCustomerUseCase: GetReOrderCustomerUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var orderDetailViewController: OrderDetailViewController
    
    init(
        orderDetailViewController: OrderDetailViewController,
        getOrderDetailUseCase: GetOrderDetailUseCase = GetOrderDetailUseCaseImpl(),
        getReOrderCustomerUseCase: GetReOrderCustomerUseCase = GetReOrderCustomerUseCaseImpl()
    ) {
        self.orderDetailViewController = orderDetailViewController
        self.getOrderDetailUseCase = getOrderDetailUseCase
        self.getReOrderCustomerUseCase = getReOrderCustomerUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetOrderDetailSuccess: (() -> Void)?
    
    public var orderDetailData: OrderDetailData?
    public var listOrderD: [OrderD]? = []
    public var listCustomer: [CustomerItems]? = []
    public var orderId: Int? = nil
    
    func setOrderId(orderId: Int?) {
        self.orderId = orderId
    }
    
    func getOrderDetail() {
        guard let orderId = orderId else { return }
        self.orderDetailViewController.startLoding()
        self.getOrderDetailUseCase.execute(orderId: orderId).sink { completion in
            debugPrint("getOrderDetail \(completion)")
            self.orderDetailViewController.stopLoding()
        } receiveValue: { resp in
            
            if let item = resp {
                self.orderDetailData = item
            }
            
            if let items = resp?.orderD {
                self.listOrderD = items
            }
            
            if let items = resp?.customer {
                self.listCustomer = [items]
            }
            
            self.didGetOrderDetailSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        switch section {
        case 0:
            return self.listCustomer?.count ?? 0
        default:
            return self.listOrderD?.count ?? 0
        }
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    func getItemViewCellHeight(indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 83
        default:
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
            switch section {
            case 0:
                header.render(title: "จัดส่งโดย")
            default:
                header.render(title: "รายการสินค้า")
            }
        }
        return header
    }
    
    func getOrderNo() -> String {
        return self.orderDetailData?.orderNo ?? ""
    }
}

extension OrderDetailViewModel {
    
    func didCreateOrder() {
        let objs = OrderCartManager.sharedInstance.getProductCart()
        if let objs = objs, objs.count > 0 {
            orderDetailViewController.showAlertComfirm(titleText: "คุณต้องการเปลี่ยนแปลง\nตะกร้าสินค้า ใช่หรือไม่ ?", messageText: "", dismissAction: {
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
        getReOrderCsutomer { items in
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
    
    func getReOrderCsutomer(completion: @escaping ([ReOrderCustomer]) -> Void) {
        guard let orderId = self.orderId else { return }
        self.orderDetailViewController.startLoding()
        self.getReOrderCustomerUseCase.execute(orderId: orderId).sink { completion in
            debugPrint("GetReOrderCustomer \(completion)")
            self.orderDetailViewController.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                completion(items)
            }
        }.store(in: &self.anyCancellable)
    }
}
