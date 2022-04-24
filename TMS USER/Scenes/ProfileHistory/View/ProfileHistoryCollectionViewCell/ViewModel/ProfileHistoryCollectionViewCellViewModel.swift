//
//  ProfileHistoryCollectionViewCellViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ProfileHistoryCollectionViewModelDelegate {
    func didCancelOrder(orderId: Int)
    func didTapOrderDatail(orderId: Int, orderItem: OrderItems?)
    func didReviewOrder(orderId: Int)
    func didTapWaitShipping(orderId: Int)
}

protocol ProfileHistoryCollectionProtocolInput {
    func setUp(vc: UIViewController?, type: IndexProfileHistoryType?, delegate: ProfileHistoryCollectionViewModelDelegate?)
    
    func getOrderWaitApproveOrder()
    func getApproveOrder()
    func getFinishOrder()
    func getRejectOrder()
    func getCancelOrder()
    func clearItemList()
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
}

protocol ProfileHistoryCollectionProtocolOutput: class {
    var didGetCellSuccess: (() -> Void)? { get set }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
    func getItemOrder() -> [OrderItems]?
    
}

protocol ProfileHistoryCollectionProtocol: ProfileHistoryCollectionProtocolInput, ProfileHistoryCollectionProtocolOutput {
    var input: ProfileHistoryCollectionProtocolInput { get }
    var output: ProfileHistoryCollectionProtocolOutput { get }
}

class ProfileHistoryCollectionViewModel: ProfileHistoryCollectionProtocol, ProfileHistoryCollectionProtocolOutput {
    
    var input: ProfileHistoryCollectionProtocolInput { return self }
    var output: ProfileHistoryCollectionProtocolOutput { return self }
    
    // MARK: - UseCase
    private var orderRepository: OrderRepository
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    public var vc: UIViewController? = nil
    public var profileHistoryType: IndexProfileHistoryType? = nil
    public var listOrder: [OrderItems]?
    public var delegate: ProfileHistoryCollectionViewModelDelegate?
    
    init(orderRepository: OrderRepository = OrderRepositoryImpl()
    ) {
        self.orderRepository = orderRepository
    }
    
    // MARK - Data-binding OutPut
    var didGetCellSuccess: (() -> Void)?
    
    func setUp(vc: UIViewController?, type: IndexProfileHistoryType?, delegate: ProfileHistoryCollectionViewModelDelegate?) {
        self.vc = vc
        self.profileHistoryType = type
        self.delegate = delegate
        
        switch self.profileHistoryType {
        case .waitApprove:
            self.getOrderWaitApproveOrder()
        case .waitShipping:
            self.getApproveOrder()
        case .success:
            self.getFinishOrder()
        case .reject:
            self.getRejectOrder()
        case .cancel:
            self.getCancelOrder()
        default:
            self.clearItemList()
            break
        }
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return self.listOrder?.count ?? 0
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if self.profileHistoryType == .waitShipping {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderSendingTableViewCell.identifier, for: indexPath) as! OrderSendingTableViewCell
            cell.selectionStyle = .none
            cell.setupValue(item: listOrder?[indexPath.item], type: self.profileHistoryType)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderProfileHistoryTableViewCell.identifier, for: indexPath) as! OrderProfileHistoryTableViewCell
            cell.selectionStyle = .none
            cell.setupValue(item: listOrder?[indexPath.item], type: self.profileHistoryType)
            cell.delegate = self
            return cell
        }
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 95
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        if let order = self.listOrder?[indexPath.item], let orderId = order.orderId, self.profileHistoryType != .waitShipping {
            self.delegate?.didTapOrderDatail(orderId: orderId, orderItem: order)
        } else if let orderId = self.listOrder?[indexPath.item].orderId, self.profileHistoryType == .waitShipping {
            self.delegate?.didTapWaitShipping(orderId: orderId)
        }
    }
    
    func clearItemList() {
        self.listOrder = []
        didGetCellSuccess?()
    }
    
    func getItemOrder() -> [OrderItems]? {
        return self.listOrder
    }
}

//MARK: - Get Item List
extension ProfileHistoryCollectionViewModel {
    func getOrderWaitApproveOrder() {
        self.vc?.startLoding()
        let request = GetOrderCustomerRequest()
        self.orderRepository.getWaitApproveOrderCustomer(request: request).sink { completion in
            debugPrint("getWaitApproveOrderCustomer \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp.data?.items {
                self.listOrder = items
            }
            self.didGetCellSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getApproveOrder() {
        self.vc?.startLoding()
        let request = GetOrderCustomerRequest()
        self.orderRepository.getApprovedOrderCustomer(request: request).sink { completion in
            debugPrint("getApprovedOrderCustomer \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp.data?.items {
                self.listOrder = items
            }
            self.didGetCellSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getFinishOrder() {
        self.vc?.startLoding()
        let request = GetOrderCustomerRequest()
        self.orderRepository.getFinishOrderCustomer(request: request).sink { completion in
            debugPrint("getFinishOrderCustomer \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp.data?.items {
                self.listOrder = items
            }
            self.didGetCellSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getRejectOrder() {
        self.vc?.startLoding()
        let request = GetOrderCustomerRequest()
        self.orderRepository.getRejectOrderCustomer(request: request).sink { completion in
            debugPrint("getRejectOrderCustomer \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp.data?.items {
                self.listOrder = items
            }
            self.didGetCellSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getCancelOrder() {
        self.vc?.startLoding()
        let request = GetOrderCustomerRequest()
        self.orderRepository.getCancelOrderCustomer(request: request).sink { completion in
            debugPrint("getCancelOrderCustomer \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp.data?.items {
                self.listOrder = items
            }
            self.didGetCellSuccess?()
        }.store(in: &self.anyCancellable)
    }
}



extension ProfileHistoryCollectionViewModel: OrderProfileHistoryTableViewCellDelegate {
    
    func didReviewOrder(orderId: Int) {
        self.delegate?.didReviewOrder(orderId: orderId)
    }
    
    func didCancelOrder(orderId: Int) {
        self.vc?.showAlertComfirm(titleText: "คุณต้องการยกเลิกคำสั่งซื้อใช่หรือไม่ ?", messageText: "", dismissAction: {
        }, confirmAction: {
            self.orderRepository.putCancelOrder(orderId: orderId).sink { completion in
                debugPrint("putCancelOrder \(completion)")
                self.vc?.stopLoding()
            } receiveValue: { resp in
                if resp.success == true, self.profileHistoryType == .waitApprove {
                    self.getOrderWaitApproveOrder()
                }
            }.store(in: &self.anyCancellable)
        })
    }
    
    func didReOrder(orderId: Int) {
        let objs = OrderCartManager.sharedInstance.getProductCart()
        if let objs = objs, objs.count > 0 {
            self.vc?.showAlertComfirm(titleText: "คุณต้องการเปลี่ยนแปลง\nตะกร้าสินค้า ใช่หรือไม่ ?", messageText: "", dismissAction: {
            }, confirmAction: {
                OrderCartManager.sharedInstance.clearProductCart {
                    self.addOrderToProductCart(orderId: orderId)
                }
            })
        } else {
            self.addOrderToProductCart(orderId: orderId)
        }
    }
    
    func addOrderToProductCart(orderId: Int) {
        getReOrderCustomer(orderId: orderId) { items in
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
    
    func getReOrderCustomer(orderId: Int, completion: @escaping ([ReOrderCustomer]) -> Void) {
        self.vc?.startLoding()
        self.orderRepository.putReOrderCustomer(orderId: orderId).sink { completion in
            debugPrint("putReOrderCustomerUseCase \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp.data {
                completion(items)
            }
        }.store(in: &self.anyCancellable)
    }
}
