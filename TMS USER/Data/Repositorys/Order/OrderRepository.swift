//
//  OrderRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import Combine
import Moya

protocol OrderRepository {
    func getApprovedOrderCustomer() -> AnyPublisher<GetApprovedOrderCustomerResponse, Error>
    func getFinishOrderCustomer() -> AnyPublisher<GetFinishOrderCustomerResponse, Error>
}

final class OrderRepositoryImpl: TMS_USER.OrderRepository {
    private let provider: MoyaProvider<OrderAPI> = MoyaProvider<OrderAPI>()
    
    func getApprovedOrderCustomer() -> AnyPublisher<GetApprovedOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getApprovedOrderCustomer)
            .map(GetApprovedOrderCustomerResponse.self)
    }
    
    func getFinishOrderCustomer() -> AnyPublisher<GetFinishOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getFinishOrderCustomer)
            .map(GetFinishOrderCustomerResponse.self)
    }
}
