//
//  ProfileHistoryViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ProfileHistoryProtocolInput {
    func didPageChange(_ index: Int, _ collectionView: UICollectionView)
}

protocol ProfileHistoryProtocolOutput: class {
    
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func getNumberOfItemsInSection(_ collectionView: UICollectionView, section: Int) -> Int
}

protocol ProfileHistoryProtocol: ProfileHistoryProtocolInput, ProfileHistoryProtocolOutput {
    var input: ProfileHistoryProtocolInput { get }
    var output: ProfileHistoryProtocolOutput { get }
}

class ProfileHistoryViewModel: ProfileHistoryProtocol, ProfileHistoryProtocolOutput {
    var input: ProfileHistoryProtocolInput { return self }
    var output: ProfileHistoryProtocolOutput { return self }
    
    // MARK: - Properties
    private var vc: ProfileHistoryViewController
    
    init(
        vc: ProfileHistoryViewController
    ) {
        self.vc = vc
    }
    
    // MARK - Data-binding OutPut
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHistoryCollectionViewCell.identifier, for: indexPath) as! ProfileHistoryCollectionViewCell
        let profileHistoryType = IndexProfileHistoryType(rawValue: indexPath.item)
        cell.viewModel.setUp(vc: self.vc, type: profileHistoryType, delegate: self)
        return cell
    }

    func getNumberOfItemsInSection(_ collectionView: UICollectionView, section: Int) -> Int {
        return 5
    }
    
    func didPageChange(_ index: Int, _ collectionView: UICollectionView) {
        let profileHistoryType = IndexProfileHistoryType(rawValue: index)
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? ProfileHistoryCollectionViewCell {
            cell.viewModel.setUp(vc: self.vc, type: profileHistoryType, delegate: self)
        }
    }
}

extension ProfileHistoryViewModel: ProfileHistoryCollectionViewModelDelegate {
    func didReviewOrder(orderId: Int) {
        NavigationManager.instance.pushVC(to: .customerReview(orderId: orderId))
    }
    
    func didTapOrderDatail(orderId: Int, orderItem: OrderItems?) {
        NavigationManager.instance.pushVC(to: .orderHistoryDetail(orderId: orderId, orderItem: orderItem))
    }
    
    func didCancelOrder(orderId: Int) {
    }
    
    func didTapWaitShipping(orderId: Int) {
        NavigationManager.instance.pushVC(to: .orderTracking(orderId: orderId))
    }
}

public enum IndexProfileHistoryType: Int {
    case waitApprove = 0
    case waitShipping = 1
    case success = 2
    case reject = 3
    case cancel = 4
}

public enum TopNavProfileHistoryType: String {
    case waitApprove = "รอการอนุมัติ"
    case waitShipping = "รอการจัดส่ง"
    case success = "สำเร็จ"
    case reject = "โดนปฏิเสธ"
    case cancel = "ยกเลิก"
}
