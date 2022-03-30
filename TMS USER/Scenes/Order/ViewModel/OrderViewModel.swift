//
//  OrderViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
import Combine

protocol OrderProtocolInput {
    func getOrder()
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
}

protocol OrderProtocolOutput: class {
    var didGetOrderSuccess: (() -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol OrderProtocol: OrderProtocolInput, OrderProtocolOutput {
    var input: OrderProtocolInput { get }
    var output: OrderProtocolOutput { get }
}

class OrderViewModel: OrderProtocol, OrderProtocolOutput {
    var input: OrderProtocolInput { return self }
    var output: OrderProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getApprovedOrderCustomerUseCase: GetApprovedOrderCustomerUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var orderViewController: OrderViewController

    init(
        orderViewController: OrderViewController,
        getApprovedOrderCustomerUseCase: GetApprovedOrderCustomerUseCase = GetApprovedOrderCustomerUseCaseImpl()
    ) {
        self.orderViewController = orderViewController
        self.getApprovedOrderCustomerUseCase = getApprovedOrderCustomerUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetOrderSuccess: (() -> Void)?
    
    public var listOrder: [OrderItems]? = []
    
    func getOrder() {
        self.orderViewController.startLoding()
        self.getApprovedOrderCustomerUseCase.execute().sink { completion in
            debugPrint("getApprovedOrderCustomer \(completion)")
            self.orderViewController.stopLoding()
        } receiveValue: { resp in
            if let items = resp?.items {
                self.listOrder = items
            }
            self.didGetOrderSuccess?()
        }.store(in: &self.anyCancellable)
    }

    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return listOrder?.count ?? 0
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        cell.selectionStyle = .none
        cell.item = listOrder?[indexPath.item]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 140
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        guard let orderId = listOrder?[indexPath.item].orderId else { return }
        NavigationManager.instance.pushVC(to: .orderTracking(orderId: orderId))
    }
}
