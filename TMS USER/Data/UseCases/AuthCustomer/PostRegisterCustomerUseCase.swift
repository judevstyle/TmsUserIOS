//
//  PostRegisterCustomerUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 30/3/2565 BE.
//

import Foundation
import Combine

protocol PostRegisterCustomerUseCase {
    func execute(request: PostRegisterCustomerRequest) -> AnyPublisher<PostAuthenticateResponse?, Error>
}

struct PostRegisterCustomerUseCaseImpl: PostRegisterCustomerUseCase {
    
    private let repository: AuthCustomerRepository
    
    init(repository: AuthCustomerRepository = AuthCustomerRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostRegisterCustomerRequest) -> AnyPublisher<PostAuthenticateResponse?, Error> {
        return repository
            .registerCustomer(request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
