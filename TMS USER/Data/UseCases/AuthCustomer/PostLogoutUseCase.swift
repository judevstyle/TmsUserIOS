//
//  PostLogoutUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import Foundation
import Combine

protocol PostLogoutUseCase {
    func execute() -> AnyPublisher<PostAuthenticateResponse?, Error>
}

struct PostLogoutUseCaseImpl: PostLogoutUseCase {
    
    private let repository: AuthCustomerRepository
    
    init(repository: AuthCustomerRepository = AuthCustomerRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<PostAuthenticateResponse?, Error> {
        return repository
            .logout()
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
