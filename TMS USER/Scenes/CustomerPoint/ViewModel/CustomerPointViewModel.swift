//
//  CustomerPointViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 2/4/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol CustomerPointProtocolInput {
    func getCustomerPoint()
    func getMyRewardPoint()
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
}

protocol CustomerPointProtocolOutput: class {
    var didGetCustomerPointSuccess: ((Int) -> Void)? { get set }
    var didGetMyRewardPointSuccess: (() -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfProfile(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol CustomerPointProtocol: CustomerPointProtocolInput, CustomerPointProtocolOutput {
    var input: CustomerPointProtocolInput { get }
    var output: CustomerPointProtocolOutput { get }
}

class CustomerPointViewModel: CustomerPointProtocol, CustomerPointProtocolOutput {
    
    var input: CustomerPointProtocolInput { return self }
    var output: CustomerPointProtocolOutput { return self }
    
    // MARK: - UseCase
    private var pointRepository: PointRepository
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: CustomerPointViewController

    init(
        vc: CustomerPointViewController,
        pointRepository: PointRepository = PointRepositoryImpl()
    ) {
        self.vc = vc
        self.pointRepository = pointRepository
    }
    
    // MARK - Data-binding OutPut
    var didGetCustomerPointSuccess: ((Int) -> Void)?
    var didGetMyRewardPointSuccess: (() -> Void)?
    
    private var listMyRewardPoint: [RewardPointItem]?
    
    func getMyRewardPoint() {
        vc.stopLoding()
        self.pointRepository.myRewardPoint().sink { completion in
            debugPrint("customerPoint \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            self.listMyRewardPoint = resp.data
            self.didGetMyRewardPointSuccess?()
        }.store(in: &self.anyCancellable)
    }
    
    func getCustomerPoint() {
        vc.stopLoding()
        self.pointRepository.customerPoint().sink { completion in
            debugPrint("customerPoint \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            let balancePoint = resp.data?.balancePoint ?? 0
            self.didGetCustomerPointSuccess?(balancePoint)
        }.store(in: &self.anyCancellable)
    }
    
    
    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getNumberOfProfile(_ tableView: UITableView, section: Int) -> Int {
        return listMyRewardPoint?.count ?? 0
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRewardPointTableViewCell.identifier, for: indexPath) as! MyRewardPointTableViewCell
        cell.selectionStyle = .none
        cell.item = listMyRewardPoint?[indexPath.item]
//        cell.title = listMenu[indexPath.item].title
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 125
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {

    }

}
