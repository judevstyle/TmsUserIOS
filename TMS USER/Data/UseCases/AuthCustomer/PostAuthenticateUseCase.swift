//
//  PostAuthenticateUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import Foundation
import Combine

protocol PostAuthenticateUseCase {
    func execute(request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse?, Error>
}

struct PostAuthenticateUseCaseImpl: PostAuthenticateUseCase {
    
    private let repository: AuthCustomerRepository
    
    init(repository: AuthCustomerRepository = AuthCustomerRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostAuthenticateRequest) -> AnyPublisher<PostAuthenticateResponse?, Error> {
        return repository
            .authenticate(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
