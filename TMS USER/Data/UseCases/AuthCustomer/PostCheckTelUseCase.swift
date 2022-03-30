//
//  PostCheckTelUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 30/3/2565 BE.
//

import Foundation
import Combine

protocol PostCheckTelUseCase {
    func execute(request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse?, Error>
}

struct PostCheckTelUseCaseImpl: PostCheckTelUseCase {
    
    private let repository: AuthCustomerRepository
    
    init(repository: AuthCustomerRepository = AuthCustomerRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse?, Error> {
        return repository
            .checkTel(request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
