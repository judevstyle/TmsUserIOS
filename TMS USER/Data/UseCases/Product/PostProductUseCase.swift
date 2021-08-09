//
//  PostProductUseCase.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 29/6/2564 BE.
//

import Foundation
import Combine

protocol PostProductUseCase {
    func execute(request: PostProductRequest) -> AnyPublisher<PostProductResponse?, Error>
}

struct PostProductUseCaseImpl: PostProductUseCase {
    
    private let repository: ProductRepository
    
    init(repository: ProductRepository = ProductRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostProductRequest) -> AnyPublisher<PostProductResponse?, Error> {
        return self.repository
            .createProduct(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
