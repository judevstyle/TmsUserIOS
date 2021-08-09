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
}
