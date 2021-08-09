//
//  ProductTypeRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import Combine
import Moya

protocol ProductTypeRepository {
    func getProductType() -> AnyPublisher<GetProductTypeResponse, Error>
}

final class ProductTypeRepositoryImpl: TMS_USER.ProductTypeRepository {
    private let provider: MoyaProvider<ProductTypeAPI> = MoyaProvider<ProductTypeAPI>()
    
    func getProductType() -> AnyPublisher<GetProductTypeResponse, Error> {
        return self.provider
            .cb
            .request(.getProductType)
            .map(GetProductTypeResponse.self)
    }
}
