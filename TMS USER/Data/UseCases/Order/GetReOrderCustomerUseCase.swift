//
//  GetReOrderCustomerUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation
import Combine

protocol GetReOrderCustomerUseCase {
    func execute(orderId: Int) -> AnyPublisher<[ReOrderCustomer]?, Error>
}

struct GetReOrderCustomerUseCaseImpl: GetReOrderCustomerUseCase {
    
    private let repository: OrderRepository
    
    init(repository: OrderRepository = OrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(orderId: Int) -> AnyPublisher<[ReOrderCustomer]?, Error> {
        return self.repository
            .getReOrderCustomer(orderId: orderId)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
