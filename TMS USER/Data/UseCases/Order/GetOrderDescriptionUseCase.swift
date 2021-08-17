//
//  GetOrderDescriptionUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/16/21.
//

import Foundation
import Combine

protocol GetOrderDescriptionUseCase {
    func execute(orderId: Int) -> AnyPublisher<GetOrderDescriptionResponse?, Error>
}

struct GetOrderDescriptionUseCaseImpl: GetOrderDescriptionUseCase {
    
    private let repository: OrderRepository
    
    init(repository: OrderRepository = OrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(orderId: Int) -> AnyPublisher<GetOrderDescriptionResponse?, Error> {
        return self.repository
            .getOrderDescription(orderId: orderId)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
