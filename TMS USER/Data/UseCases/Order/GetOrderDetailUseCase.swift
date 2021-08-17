//
//  GetOrderDetailUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation
import Combine

protocol GetOrderDetailUseCase {
    func execute(orderId: Int) -> AnyPublisher<OrderDetailData?, Error>
}

struct GetOrderDetailUseCaseImpl: GetOrderDetailUseCase {
    
    private let repository: OrderRepository
    
    init(repository: OrderRepository = OrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(orderId: Int) -> AnyPublisher<OrderDetailData?, Error> {
        return self.repository
            .getOrderDetail(orderId: orderId)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
