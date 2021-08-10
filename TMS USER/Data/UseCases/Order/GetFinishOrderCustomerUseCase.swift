//
//  GetFinishOrderCustomerUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import Foundation
import Combine

protocol GetFinishOrderCustomerUseCase {
    func execute() -> AnyPublisher<OrderData?, Error>
}

struct GetFinishOrderCustomerUseCaseImpl: GetFinishOrderCustomerUseCase {
    
    private let repository: OrderRepository
    
    init(repository: OrderRepository = OrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<OrderData?, Error> {
        return self.repository
            .getFinishOrderCustomer()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
