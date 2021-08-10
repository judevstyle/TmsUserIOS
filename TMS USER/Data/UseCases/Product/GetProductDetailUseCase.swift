//
//  GetProductDetailUseCase.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 28/6/2564 BE.
//

import Foundation
import Combine

protocol GetProductDetailUseCase {
    func execute(productId: Int) -> AnyPublisher<ProductItems?, Error>
}

struct GetProductDetailUseCaseImpl: GetProductDetailUseCase {
    
    private let repository: ProductRepository
    
    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(productId: Int) -> AnyPublisher<ProductItems?, Error> {
        return self.repository
            .getProductDetail(productId: productId)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
