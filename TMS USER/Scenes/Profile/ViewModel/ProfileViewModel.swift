//
//  ProfileViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
import Combine

protocol ProfileProtocolInput {
    func getProfile()
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
    func getCustomerPoint()
}

protocol ProfileProtocolOutput: class {
    var didGetProfileSuccess: (() -> Void)? { get set }
    var didLogoutSuccess: (() -> Void)? { get set }
    var didGetCustomerPointSuccess: ((Int) -> Void)? { get set }
    
    func getNumberOfSections(in tableView: UITableView) -> Int
    func getNumberOfProfile(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol ProfileProtocol: ProfileProtocolInput, ProfileProtocolOutput {
    var input: ProfileProtocolInput { get }
    var output: ProfileProtocolOutput { get }
}

class ProfileViewModel: ProfileProtocol, ProfileProtocolOutput {
    var input: ProfileProtocolInput { return self }
    var output: ProfileProtocolOutput { return self }
    
    // MARK: - UseCase
    private var postLogoutUseCase: PostLogoutUseCase
    private var getCustomerMyUserUseCase: GetCustomerMyUserUseCase
    private var pointRepository: PointRepository
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: ProfileViewController
    
    fileprivate var orderId: Int?
    fileprivate var listMenu: [MenuProfileType] = [.personalData, .pointAndReward, .historyOrder, .logout]

    init(
        vc: ProfileViewController,
        postLogoutUseCase: PostLogoutUseCase = PostLogoutUseCaseImpl(),
        getCustomerMyUserUseCase: GetCustomerMyUserUseCase = GetCustomerMyUserUseCaseImpl(),
        pointRepository: PointRepository = PointRepositoryImpl()
    ) {
        self.vc = vc
        self.postLogoutUseCase = postLogoutUseCase
        self.getCustomerMyUserUseCase = getCustomerMyUserUseCase
        self.pointRepository = pointRepository
    }
    
    // MARK - Data-binding OutPut
    var didGetProfileSuccess: (() -> Void)?
    var didGetCustomerPointSuccess: ((Int) -> Void)?
    
    var didLogoutSuccess: (() -> Void)?
    
    func getProfile() {
        vc.startLoding()
        self.getCustomerMyUserUseCase.execute().sink { completion in
            debugPrint("getCustomerMyUser \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                AppDelegate.shareDelegate.userProfile = items
                self.didGetProfileSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getCustomerPoint() {
        vc.startLoding()
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
        return listMenu.count
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.selectionStyle = .none
        cell.title = listMenu[indexPath.item].title
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 44
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        let type: MenuProfileType = self.listMenu[indexPath.item]
        switch type {
        case .personalData:
            NavigationManager.instance.pushVC(to: .manageProfile)
        case .pointAndReward:
            NavigationManager.instance.pushVC(to: .customerPoint)
        case .logout:
            vc.showAlertComfirm(titleText: "คุณต้องการออกจากระบบ\nใช่หรือไม่ ?", messageText: "", dismissAction: {
            }, confirmAction: {
                self.handleLogout()
            })
            break
        default:
            break
        }
    }
    
    private func handleLogout() {
        vc.startLoding()
        self.postLogoutUseCase.execute().sink { completion in
            debugPrint("postLogout \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                if  items.success == true {
                    UserDefaultsKey.AccessToken.remove()
                    UserDefaultsKey.ExpireAccessToken.remove()
                    self.didLogoutSuccess?()
                } else {
                    UserDefaultsKey.AccessToken.remove()
                    UserDefaultsKey.ExpireAccessToken.remove()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.didLogoutSuccess?()
                    }
                }
            }
        }.store(in: &self.anyCancellable)
    }
}


enum MenuProfileType {
    case personalData
    case pointAndReward
    case historyOrder
    case logout
    
    var title: String {
        switch self {
        case .personalData:
            return "จัดการข้อมูลส่วนตัว"
        case .pointAndReward:
            return "คะแนนสะแสมและของแลก"
        case .historyOrder:
            return "ประวัติการสั่งซื้อ"
        case .logout:
            return "ออกจากระบบ"
        default:
            return ""
        }
    }
}
