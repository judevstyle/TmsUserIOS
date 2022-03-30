//
//  HistoryViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
import Combine

protocol HistoryProtocolInput {
    func getHistory()
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
}

protocol HistoryProtocolOutput: class {
    var didGetHistorySuccess: (() -> Void)? { get set }
    var didNavigateOrderDetail: ((Int?) -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol HistoryProtocol: HistoryProtocolInput, HistoryProtocolOutput {
    var input: HistoryProtocolInput { get }
    var output: HistoryProtocolOutput { get }
}

class HistoryViewModel: HistoryProtocol, HistoryProtocolOutput {
    var input: HistoryProtocolInput { return self }
    var output: HistoryProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getFinishOrderCustomerUseCase: GetFinishOrderCustomerUseCase
    private var getReOrderCustomerUseCase: GetReOrderCustomerUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var historyViewController: HistoryViewController
    
    init(
        historyViewController: HistoryViewController,
        getFinishOrderCustomerUseCase: GetFinishOrderCustomerUseCase = GetFinishOrderCustomerUseCaseImpl(),
        getReOrderCustomerUseCase: GetReOrderCustomerUseCase = GetReOrderCustomerUseCaseImpl()
    ) {
        self.historyViewController = historyViewController
        self.getFinishOrderCustomerUseCase = getFinishOrderCustomerUseCase
        self.getReOrderCustomerUseCase = getReOrderCustomerUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetHistorySuccess: (() -> Void)?
    var didNavigateOrderDetail: ((Int?) -> Void)?
    
    public var listOrder: [OrderItems]? = []
    
    func getHistory() {
        self.historyViewController.startLoding()
        self.getFinishOrderCustomerUseCase.execute().sink { completion in
            debugPrint("getFinishOrderCustomer \(completion)")
            self.historyViewController.stopLoding()
        } receiveValue: { resp in
            if let items = resp?.items {
                self.listOrder = items
            }
            self.didGetHistorySuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return listOrder?.count ?? 0
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath.item
        cell.item = listOrder?[indexPath.item]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 95
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
//        NavigationManager.instance.pushVC(to: .orderDetail)
        didNavigateOrderDetail?(self.listOrder?[indexPath.item].orderId)
    }
}


extension HistoryViewModel: HistoryTableViewCellDelegate {
    func didCreateOrder(index: Int?) {
        let objs = OrderCartManager.sharedInstance.getProductCart()
        if let objs = objs, objs.count > 0 {
            historyViewController.showAlertComfirm(titleText: "คุณต้องการเปลี่ยนแปลง\nตะกร้าสินค้า ใช่หรือไม่ ?", messageText: "", dismissAction: {
            }, confirmAction: {
                OrderCartManager.sharedInstance.clearProductCart {
                    self.addOrderToProductCart(index: index)
                }
            })
        } else {
            addOrderToProductCart(index: index)
        }
    }
    
    func addOrderToProductCart(index: Int?) {
        getReOrderCsutomer(index: index) { items in
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
    
    func getReOrderCsutomer(index: Int?, completion: @escaping ([ReOrderCustomer]) -> Void) {
        guard let index = index,
              let orderId = self.listOrder?[index].orderId else { return }
        
        self.historyViewController.startLoding()
        self.getReOrderCustomerUseCase.execute(orderId: orderId).sink { completion in
            debugPrint("GetReOrderCustomer \(completion)")
            self.historyViewController.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                completion(items)
            }
        }.store(in: &self.anyCancellable)
    }
}
