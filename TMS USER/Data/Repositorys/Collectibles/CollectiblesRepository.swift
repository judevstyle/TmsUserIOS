//
//  CollectiblesRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 3/4/2565 BE.
//

import Foundation
import Combine
import Moya

protocol CollectiblesRepository {
    func collectibleForUser(request: GetCollectiblesForUserRequest) -> AnyPublisher<GetCollectiblesForUserResponse, Error>
}

final class CollectiblesRepositoryImpl: TMS_USER.CollectiblesRepository {
    private let provider: MoyaProvider<CollectiblesAPI> = MoyaProvider<CollectiblesAPI>()
    
    func collectibleForUser(request: GetCollectiblesForUserRequest) -> AnyPublisher<GetCollectiblesForUserResponse, Error> {
        return self.provider
            .cb
            .request(.collectibleForUser(request: request))
            .map(GetCollectiblesForUserResponse.self)
    }
    
}
