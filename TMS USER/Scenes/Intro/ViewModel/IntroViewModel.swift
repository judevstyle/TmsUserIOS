//
//  IntroViewModel.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
import Combine

protocol IntroProtocolInput {
    func checkAuth()
}

protocol IntroProtocolOutput: class {
    var didAuthSuccess: (() -> Void)? { get set }
}

protocol IntroProtocol: IntroProtocolInput, IntroProtocolOutput {
    var input: IntroProtocolInput { get }
    var output: IntroProtocolOutput { get }
}

class IntroViewModel: IntroProtocol, IntroProtocolOutput {
    var input: IntroProtocolInput { return self }
    var output: IntroProtocolOutput { return self }
    
    // MARK: - Properties
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var introViewController: IntroViewController
    
    init(
        introViewController: IntroViewController
    ) {
        self.introViewController = introViewController
    }
    
    // MARK - Data-binding OutPut
    var didAuthSuccess: (() -> Void)?
    
    
    func checkAuth() {
//        introViewController.startLoding()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.introViewController.stopLoding()
//            self.didAuthSuccess?()
//        }
        
        if let accessToken = UserDefaultsKey.AccessToken.string, accessToken != "",
           let expireAccessToken = UserDefaultsKey.ExpireAccessToken.string, expireAccessToken != "",
           let expireDate = expireAccessToken.convertToDate(),
           Date() < expireDate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.didAuthSuccess?()
            }
            debugPrint("AccessToken \(accessToken)")
        }
    }
}
