//
//  GetCustomerMyUserUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation
import Combine

protocol GetCustomerMyUserUseCase {
    func execute() -> AnyPublisher<CustomerItems?, Error>
}

struct GetCustomerMyUserUseCaseImpl: GetCustomerMyUserUseCase {
    
    private let repository: CustomerRepository
    
    init(repository: CustomerRepository = CustomerRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<CustomerItems?, Error> {
        return self.repository
            .getMyUser()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
