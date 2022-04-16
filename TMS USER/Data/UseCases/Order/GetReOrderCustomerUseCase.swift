//
//  GetReOrderCustomerUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation
import Combine

protocol PutReOrderCustomerUseCase {
    func execute(orderId: Int) -> AnyPublisher<[ReOrderCustomer]?, Error>
}

struct PutReOrderCustomerUseCaseImpl: PutReOrderCustomerUseCase {
    
    private let repository: OrderRepository
    
    init(repository: OrderRepository = OrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(orderId: Int) -> AnyPublisher<[ReOrderCustomer]?, Error> {
        return self.repository
            .putReOrderCustomer(orderId: orderId)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
