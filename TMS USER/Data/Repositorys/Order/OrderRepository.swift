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
    func getOrderDetail(orderId: Int) -> AnyPublisher<GetOrderDetailResponse, Error>
    func getReOrderCustomer(orderId: Int) -> AnyPublisher<GetReOrderCustomerResponse, Error>
    func createOrderByUser(request: PostCreateOrderByUserRequest) -> AnyPublisher<PostCreateOrderByUserResponse, Error>
    func getOrderDescription(orderId: Int) -> AnyPublisher<GetOrderDescriptionResponse, Error>
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
    
    func getOrderDetail(orderId: Int) -> AnyPublisher<GetOrderDetailResponse, Error> {
        return self.provider
            .cb
            .request(.getOrderDetail(orderId: orderId))
            .map(GetOrderDetailResponse.self)
    }
    
    func getReOrderCustomer(orderId: Int) -> AnyPublisher<GetReOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getReOrderCustomer(orderId: orderId))
            .map(GetReOrderCustomerResponse.self)
    }
    
    func createOrderByUser(request: PostCreateOrderByUserRequest) -> AnyPublisher<PostCreateOrderByUserResponse, Error> {
        return self.provider
            .cb
            .request(.createOrderByUser(request: request))
            .map(PostCreateOrderByUserResponse.self)
    }
    
    func getOrderDescription(orderId: Int) -> AnyPublisher<GetOrderDescriptionResponse, Error> {
        return self.provider
            .cb
            .request(.getOrderDescription(orderId: orderId))
            .map(GetOrderDescriptionResponse.self)
    }
}
