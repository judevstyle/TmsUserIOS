//
//  ProductRepository.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 28/6/2564 BE.
//

import Foundation
import Combine
import Moya

protocol ProductRepository {
    func getProduct(request: GetProductRequest) -> AnyPublisher<GetProductResponse, Error>
    func getProductDetail(productId: Int) -> AnyPublisher<GetProductDetailResponse, Error>
    func createProduct(request: PostProductRequest) -> AnyPublisher<PostProductResponse, Error>
}

final class ProductRepositoryImpl: TMS_USER.ProductRepository {
    private let provider: MoyaProvider<ProductAPI> = MoyaProvider<ProductAPI>()
    
    func getProduct(request: GetProductRequest) -> AnyPublisher<GetProductResponse, Error> {
        return self.provider
            .cb
            .request(.getProduct(request: request))
            .map(GetProductResponse.self)
    }
    
    func getProductDetail(productId: Int) -> AnyPublisher<GetProductDetailResponse, Error> {
        return self.provider
            .cb
            .request(.getProductDetail(productId: productId))
            .map(GetProductDetailResponse.self)
    }
    
    func createProduct(request: PostProductRequest) -> AnyPublisher<PostProductResponse, Error> {
        return self.provider
            .cb
            .request(.createProduct(request: request))
            .map(PostProductResponse.self)
    }
}
