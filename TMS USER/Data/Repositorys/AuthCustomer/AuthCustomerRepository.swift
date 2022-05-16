//
//  AuthCustomerRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import Foundation
import Combine
import Moya

protocol AuthCustomerRepository {
    func authenticate(request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse, Error>
    func logout() -> AnyPublisher<PostAuthenticateResponse, Error>
    func checkTelRegister(_ request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse, Error>
    func registerCustomer(_ request: PostRegisterCustomerRequest) -> AnyPublisher<PostAuthenticateResponse, Error>
    func updateProfile(_ request: PostRegisterCustomerRequest) -> AnyPublisher<PutUpdateProfileResponse, Error>
    func checkTelLogin(_ request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse, Error>
}

final class AuthCustomerRepositoryImpl: TMS_USER.AuthCustomerRepository {
    private let provider: MoyaProvider<AuthCustomerAPI> = MoyaProvider<AuthCustomerAPI>()

    func authenticate(request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse, Error> {
        return self.provider
            .cb
            .request(.authenticate(request: request))
            .map(PostAuthenticateResponse.self)
    }
    
    func logout() -> AnyPublisher<PostAuthenticateResponse, Error> {
        return self.provider
            .cb
            .request(.logout)
            .map(PostAuthenticateResponse.self)
    }
    
    func checkTelRegister(_ request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse, Error> {
        return self.provider
            .cb
            .request(.checkTelRegister(request))
            .map(PostAuthenticateResponse.self)
    }
    
    func registerCustomer(_ request: PostRegisterCustomerRequest) -> AnyPublisher<PostAuthenticateResponse, Error> {
        return self.provider
            .cb
            .request(.registerCustomer(request))
            .map(PostAuthenticateResponse.self)
    }
    
    func updateProfile(_ request: PostRegisterCustomerRequest) -> AnyPublisher<PutUpdateProfileResponse, Error> {
        return self.provider
            .cb
            .request(.updateProfile(request))
            .map(PutUpdateProfileResponse.self)
    }
    
    func checkTelLogin(_ request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse, Error> {
        return self.provider
            .cb
            .request(.checkTelLogin(request))
            .map(PostAuthenticateResponse.self)
    }
}
