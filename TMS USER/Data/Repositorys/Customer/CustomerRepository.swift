//
//  CustomerRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation
import Combine
import Moya

protocol CustomerRepository {
    func getMyUser() -> AnyPublisher<GetCustomerMyUserResponse, Error>
}

final class CustomerRepositoryImpl: TMS_USER.CustomerRepository {
    private let provider: MoyaProvider<CustomerAPI> = MoyaProvider<CustomerAPI>()
    
    func getMyUser() -> AnyPublisher<GetCustomerMyUserResponse, Error> {
        return self.provider
            .cb
            .request(.getMyUser)
            .map(GetCustomerMyUserResponse.self)
    }
}
