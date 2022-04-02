//
//  PointRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 31/3/2565 BE.
//

import Foundation
import Combine
import Moya

protocol PointRepository {
    func customerPoint() -> AnyPublisher<GetCustomerPointResponse, Error>
    func myRewardPoint() -> AnyPublisher<GetMyRewardPointResponse, Error>
}

final class PointRepositoryImpl: TMS_USER.PointRepository {
    private let provider: MoyaProvider<PointAPI> = MoyaProvider<PointAPI>()
    
    func customerPoint() -> AnyPublisher<GetCustomerPointResponse, Error> {
        return self.provider
            .cb
            .request(.customerPoint)
            .map(GetCustomerPointResponse.self)
    }
    
    func myRewardPoint() -> AnyPublisher<GetMyRewardPointResponse, Error> {
        return self.provider
            .cb
            .request(.myRewardPoint)
            .map(GetMyRewardPointResponse.self)
    }
}
