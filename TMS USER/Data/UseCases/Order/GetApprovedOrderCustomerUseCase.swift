//
//  GetApprovedOrderCustomerUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import Combine

protocol GetApprovedOrderCustomerUseCase {
    func execute() -> AnyPublisher<OrderData?, Error>
}

struct GetApprovedOrderCustomerUseCaseImpl: GetApprovedOrderCustomerUseCase {
    
    private let repository: OrderRepository
    
    init(repository: OrderRepository = OrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<OrderData?, Error> {
        return self.repository
            .getApprovedOrderCustomer()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
