//
//  PutUpdateProfileUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 1/4/2565 BE.
//

import Foundation
import Combine

protocol PutUpdateProfileUseCase {
    func execute(request: PostRegisterCustomerRequest) -> AnyPublisher<PutUpdateProfileResponse?, Error>
}

struct PutUpdateProfileUseCaseImpl: PutUpdateProfileUseCase {
    
    private let repository: AuthCustomerRepository
    
    init(repository: AuthCustomerRepository = AuthCustomerRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostRegisterCustomerRequest) -> AnyPublisher<PutUpdateProfileResponse?, Error> {
        return repository
            .updateProfile(request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
