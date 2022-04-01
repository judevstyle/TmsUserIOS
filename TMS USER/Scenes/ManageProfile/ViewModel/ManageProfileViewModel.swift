//
//  ManageManageProfileViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 31/3/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ManageProfileProtocolInput {
    func getProfile()
}

protocol ManageProfileProtocolOutput: class {
    var didGetProfileSuccess: (() -> Void)? { get set }
}

protocol ManageProfileProtocol: ManageProfileProtocolInput, ManageProfileProtocolOutput {
    var input: ManageProfileProtocolInput { get }
    var output: ManageProfileProtocolOutput { get }
}

class ManageProfileViewModel: ManageProfileProtocol, ManageProfileProtocolOutput {
    var input: ManageProfileProtocolInput { return self }
    var output: ManageProfileProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getCustomerMyUserUseCase: GetCustomerMyUserUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: ManageProfileViewController

    init(
        vc: ManageProfileViewController,
        getCustomerMyUserUseCase: GetCustomerMyUserUseCase = GetCustomerMyUserUseCaseImpl()
    ) {
        self.vc = vc
        self.getCustomerMyUserUseCase = getCustomerMyUserUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetProfileSuccess: (() -> Void)?
    
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

}
