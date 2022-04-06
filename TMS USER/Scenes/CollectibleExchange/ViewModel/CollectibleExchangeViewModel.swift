//
//  CollectibleExchangeViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 5/4/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol CollectibleExchangeProtocolInput {
    func getCollectibleForUser()
    func setCustomerPoint(_ point: Int)
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
}

protocol CollectibleExchangeProtocolOutput: class {
    var didGetCollectibleExchangeSuccess: (() -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol CollectibleExchangeProtocol: CollectibleExchangeProtocolInput, CollectibleExchangeProtocolOutput {
    var input: CollectibleExchangeProtocolInput { get }
    var output: CollectibleExchangeProtocolOutput { get }
}

class CollectibleExchangeViewModel: CollectibleExchangeProtocol, CollectibleExchangeProtocolOutput {
    var input: CollectibleExchangeProtocolInput { return self }
    var output: CollectibleExchangeProtocolOutput { return self }
    
    // MARK: - UseCase
    private var collectiblesRepository: CollectiblesRepository
    private var pointRepository: PointRepository
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: CollectibleExchangeViewController
    
    init(
        vc: CollectibleExchangeViewController,
        collectiblesRepository: CollectiblesRepository = CollectiblesRepositoryImpl(),
        pointRepository: PointRepository = PointRepositoryImpl()
    ) {
        self.vc = vc
        self.collectiblesRepository = collectiblesRepository
        self.pointRepository = pointRepository
    }
    
    // MARK - Data-binding OutPut
    var didGetCollectibleExchangeSuccess: (() -> Void)?
    
    public var dataCollectibles: CollectiblesForUserData?
    
    private var customerPoint: Int = 0
    
    private var selectedItemExchange: CollectibleItems? = nil
    
    func setCustomerPoint(_ point: Int) {
        self.customerPoint = point
    }
    
    func getCollectibleForUser() {
        self.vc.startLoding()
        var request = GetCollectiblesForUserRequest()
        request.limit = 10
        request.page = 1
        self.collectiblesRepository.collectibleForUser(request: request).sink { completion in
            debugPrint("getCollectibleForUser \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let data = resp.data {
                self.dataCollectibles = data
                self.didGetCollectibleExchangeSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getNumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return self.dataCollectibles?.items?.count ?? 0
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectibleTableViewCell.identifier, for: indexPath) as! CollectibleTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        if let listCollectibles = dataCollectibles?.items {
            cell.item = listCollectibles[indexPath.item]
        }
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 130
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
    }
    
    func rewardPoint(item: CollectibleItems, status: ((Bool) -> Void)?) {
        guard let clbId = item.clbId else {
            status?(false)
            return
        }
        self.pointRepository.rewardPoint(clbId).sink { completion in
            debugPrint("PostRewardPoint \(completion)")
            switch completion {
            case .failure:
                status?(false)
            default:
                break
            }
        } receiveValue: { resp in
            debugPrint(resp)
            if let isSuccess = resp.data?.isSuccess, isSuccess == true {
                status?(true)
            } else {
                status?(false)
            }
        }.store(in: &self.anyCancellable)
    }
}

//MARK: - CollectibleTableViewCellDelegate
extension CollectibleExchangeViewModel: CollectibleTableViewCellDelegate {
    func didTapExchange(_ item: CollectibleItems?) {
        if let rewardPoint = item?.rewardPoint, self.customerPoint >= rewardPoint  {
            self.selectedItemExchange = item
            let msg = AcceptDialogMsg(title: "คุณต้องการยืนยันการแลกหรือไม่", pointBalance: "เหรียญสะสมทั้งหมดของคุณ \(self.customerPoint)", usePoint: "ใช้เหรียญจำนวน \(rewardPoint) เหรียญ")
            NavigationManager.instance.pushVC(
                to: .dialogMessage(delegate: self, .confirm,
                                   msgAccept: msg),
                presentation: .ModalFullScreen(completion: nil))
        } else {
            self.selectedItemExchange = nil
            let msg = ErrorDialogMsg(title: "จำนวนเหรียญไม่เพียงพอ")
            NavigationManager.instance.pushVC(
                to: .dialogMessage(delegate: self, .error,
                                   msgError: msg),
                presentation: .ModalFullScreen(completion: nil))
        }
    }
}

extension CollectibleExchangeViewModel: DialogMessageViewControllerDelegate {
    func didAccept(_ type: DialogMessageType, vc: UIViewController) {
        guard let item = self.selectedItemExchange else {
            vc.dismiss(animated: true, completion: nil)
            return
        }
        vc.startLoding()
        self.rewardPoint(item: item) { status in
            vc.dismiss(animated: true, completion: {
                self.selectedItemExchange = nil
                vc.stopLoding()
                if status == true {
                    let msg = SuccessDialogMsg(title: "ยินดีด้วย การแลกของสะสมของคุณสำเร็จแล้ว")
                    NavigationManager.instance.pushVC(
                        to: .dialogMessage(delegate: self, .success,
                                           msgSuccess: msg),
                        presentation: .ModalFullScreen(completion: nil))
                    self.getCollectibleForUser()
                }
            })
        }
    }
}
