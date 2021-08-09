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
}

protocol ProfileProtocolOutput: class {
    var didGetProfileSuccess: (() -> Void)? { get set }
    var didGetProfileError: (() -> Void)? { get set }
    
    var didLogoutSuccess: (() -> Void)? { get set }
    
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
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var profileViewController: ProfileViewController
    
    fileprivate var orderId: Int?
    fileprivate var listMenu: [MenuProfileType] = [.personalData, .pointAndReward, .historyOrder, .logout]

    init(
        profileViewController: ProfileViewController,
        postLogoutUseCase: PostLogoutUseCase = PostLogoutUseCaseImpl()
    ) {
        self.profileViewController = profileViewController
        self.postLogoutUseCase = postLogoutUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetProfileSuccess: (() -> Void)?
    var didGetProfileError: (() -> Void)?
    
    var didLogoutSuccess: (() -> Void)?
    
    func getProfile() {
        didGetProfileSuccess?()
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
        case .logout:
            profileViewController.showAlertComfirm(titleText: "คุณต้องการออกจากระบบ ใช่หรือไม่ ?", messageText: "", dismissAction: {
            }, confirmAction: {
                self.handleLogout()
            })
            break
        default:
            break
        }
    }
    
    private func handleLogout() {
        profileViewController.startLoding()
        self.postLogoutUseCase.execute().sink { completion in
            debugPrint("postLogout \(completion)")
            self.profileViewController.stopLoding()
            
            switch completion {
            case .finished:
                break
            case .failure(_):
                ToastManager.shared.toastCallAPI(title: "Logout failure")
                break
            }
            
        } receiveValue: { resp in
            if let items = resp {
                if  items.success == true {
                    UserDefaultsKey.AccessToken.remove()
                    UserDefaultsKey.ExpireAccessToken.remove()
                    self.didLogoutSuccess?()
                    ToastManager.shared.toastCallAPI(title: "Logout success")
                } else {
                    UserDefaultsKey.AccessToken.remove()
                    UserDefaultsKey.ExpireAccessToken.remove()
                    ToastManager.shared.toastCallAPI(title: "\(items.message ?? "")")
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
