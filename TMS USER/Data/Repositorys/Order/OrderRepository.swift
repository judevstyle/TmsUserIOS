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
    func getApprovedOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error>
    func getFinishOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error>
    func getWaitApproveOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error>
    func getRejectOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error>
    func getCancelOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error>
    
    
    func getOrderDetail(orderId: Int) -> AnyPublisher<GetOrderDetailResponse, Error>
    func createOrderByUser(request: PostCreateOrderByUserRequest) -> AnyPublisher<PostCreateOrderByUserResponse, Error>
    func getOrderDescription(orderId: Int) -> AnyPublisher<GetOrderDescriptionResponse, Error>
    
    func putReOrderCustomer(orderId: Int) -> AnyPublisher<GetReOrderCustomerResponse, Error>
    func putCancelOrder(orderId: Int) -> AnyPublisher<PutCancelOrderResponse, Error>
}

final class OrderRepositoryImpl: TMS_USER.OrderRepository {
    private let provider: MoyaProvider<OrderAPI> = MoyaProvider<OrderAPI>()
    
    func getApprovedOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getApprovedOrderCustomer(request: request))
            .map(GetOrderCustomerResponse.self)
    }
    
    func getFinishOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getFinishOrderCustomer(request: request))
            .map(GetOrderCustomerResponse.self)
    }
    
    func getWaitApproveOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getWaitApproveOrderCustomer(request: request))
            .map(GetOrderCustomerResponse.self)
    }
    
    func getRejectOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getRejectOrderCustomer(request: request))
            .map(GetOrderCustomerResponse.self)
    }
    
    func getCancelOrderCustomer(request: GetOrderCustomerRequest) -> AnyPublisher<GetOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getCancelOrderCustomer(request: request))
            .map(GetOrderCustomerResponse.self)
    }
    
    
    // MARK: - BY ORDER ID
    
    func getOrderDetail(orderId: Int) -> AnyPublisher<GetOrderDetailResponse, Error> {
        return self.provider
            .cb
            .request(.getOrderDetail(orderId: orderId))
            .map(GetOrderDetailResponse.self)
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
    
    // MARK: - PUT
    func putCancelOrder(orderId: Int) -> AnyPublisher<PutCancelOrderResponse, Error> {
        return self.provider
            .cb
            .request(.putCancelOrder(orderId: orderId))
            .map(PutCancelOrderResponse.self)
    }
    
    func putReOrderCustomer(orderId: Int) -> AnyPublisher<GetReOrderCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.putReOrderCustomer(orderId: orderId))
            .map(GetReOrderCustomerResponse.self)
    }
}
