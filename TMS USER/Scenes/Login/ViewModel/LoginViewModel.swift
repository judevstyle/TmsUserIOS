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
    func authLogin(request: PostAuthenticateRequest)
}

protocol LoginProtocolOutput: class {
    var didLoginSuccess: (() -> Void)? { get set }
    var didLoginError: (() -> Void)? { get set }
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
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    
    private var loginViewController: LoginViewController
    
    init(
        loginViewController: LoginViewController,
        postAuthenticateUseCase: PostAuthenticateUseCase = PostAuthenticateUseCaseImpl()
    ) {
        self.loginViewController = loginViewController
        self.postAuthenticateUseCase = postAuthenticateUseCase
    }
    
    // MARK - Data-binding OutPut
    var didLoginSuccess: (() -> Void)?
    var didLoginError: (() -> Void)?
    
    func authLogin(request: PostAuthenticateRequest) {
        loginViewController.startLoding()
        self.postAuthenticateUseCase.execute(request: request).sink { completion in
            debugPrint("postAuthenticate \(completion)")
            self.loginViewController.stopLoding()
            
            switch completion {
            case .finished:
                break
            case .failure(_):
                ToastManager.shared.toastCallAPI(title: "Login failure")
                break
            }
            
        } receiveValue: { resp in
            if let items = resp {
                if  items.success == true {
                    if let accessToken = items.data?.accessToken, let expireAccessToken = items.data?.expire {
                        debugPrint(accessToken)
                        UserDefaultsKey.AccessToken.set(value: accessToken)
                        UserDefaultsKey.ExpireAccessToken.set(value: expireAccessToken)
                        ToastManager.shared.toastCallAPI(title: "Login success")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.didLoginSuccess?()
                        }
                    }
                } else {
                    ToastManager.shared.toastCallAPI(title: "\(items.message ?? "")")
                }
            }
        }.store(in: &self.anyCancellable)
    }
    
}
