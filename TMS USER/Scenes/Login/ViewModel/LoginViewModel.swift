//
//  LoginViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import Foundation
import UIKit
import Combine

protocol LoginProtocolInput {
    func authLogin()
    func checkTel(request: PostAuthenticateRequest)
}

protocol LoginProtocolOutput: class {
    var didLoginSuccess: (() -> Void)? { get set }
    var didCheckTelSuccess: (() -> Void)? { get set }
}

protocol LoginProtocol: LoginProtocolInput, LoginProtocolOutput {
    var input: LoginProtocolInput { get }
    var output: LoginProtocolOutput { get }
}

class LoginViewModel: LoginProtocol, LoginProtocolOutput {
    var input: LoginProtocolInput { return self }
    var output: LoginProtocolOutput { return self }
    
    // MARK: - Properties
    private var postAuthenticateUseCase: PostAuthenticateUseCase
    private var authCustomerRepository: AuthCustomerRepository
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    
    private var vc: LoginViewController
    private var requestAuth: PostAuthenticateRequest? = nil
    
    init(
        vc: LoginViewController,
        postAuthenticateUseCase: PostAuthenticateUseCase = PostAuthenticateUseCaseImpl(),
        authCustomerRepository: AuthCustomerRepository = AuthCustomerRepositoryImpl()
    ) {
        self.vc = vc
        self.postAuthenticateUseCase = postAuthenticateUseCase
        self.authCustomerRepository = authCustomerRepository
    }
    
    // MARK - Data-binding OutPut
    var didLoginSuccess: (() -> Void)?
    var didCheckTelSuccess: (() -> Void)?
    
    func authLogin() {
        guard let request = self.requestAuth else { return }
        vc.startLoding()
        self.postAuthenticateUseCase.execute(request: request).sink { completion in
            debugPrint("postAuthenticate \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                if  items.success == true {
                    if let accessToken = items.data?.accessToken, let expireAccessToken = items.data?.expire {
                        debugPrint(accessToken)
                        UserDefaultsKey.AccessToken.set(value: accessToken)
                        UserDefaultsKey.ExpireAccessToken.set(value: expireAccessToken)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.didLoginSuccess?()
                        }
                    }
                }
            }
        }.store(in: &self.anyCancellable)
    }
    
    func checkTel(request: PostAuthenticateRequest) {
        vc.startLoding()
        self.authCustomerRepository.checkTelLogin(request).sink { completion in
            debugPrint("checkTelLogin \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if resp.statusCode == 200, resp.success == true, let tel = request.tel, !tel.isEmpty {
                self.requestAuth = request
                self.didCheckTelSuccess?()
                NavigationManager.instance.pushVC(to: .confirmOTPView(delegate: self, phone: tel), presentation: .ModalNoNav(completion: nil))
            } else {
                if let msg = resp.message {
                    ToastManager.shared.toastCallAPI(title: "\(msg)")
                }
            }
        }.store(in: &self.anyCancellable)
    }
}

extension LoginViewModel: ConfirmOTPViewModelDelegate {
    func didConfirmOTPSuccess() {
        self.authLogin()
    }
}
