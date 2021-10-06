//
//  GetProductDescForUserUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/3/21.
//

import Foundation
import Combine

protocol GetProductDescForUserUseCase {
    func execute(productId: Int) -> AnyPublisher<ProductItems?, Error>
}

struct GetProductDescForUserUseCaseImpl: GetProductDescForUserUseCase {
    
    private let repository: ProductRepository
    
    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(productId: Int) -> AnyPublisher<ProductItems?, Error> {
        return self.repository
            .getProductDescForUser(productId: productId)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
