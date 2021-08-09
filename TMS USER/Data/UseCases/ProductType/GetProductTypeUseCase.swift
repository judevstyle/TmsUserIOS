//
//  GetProductTypeUseCase.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 27/6/2564 BE.
//

import Foundation
import Combine

protocol GetProductTypeUseCase {
    func execute() -> AnyPublisher<[ProductType]?, Error>
}

struct GetProductTypeUseCaseImpl: GetProductTypeUseCase {
    
    private let repository: ProductTypeRepository
    
    init(repository: ProductTypeRepository = ProductTypeRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[ProductType]?, Error> {
        return repository
            .getProductType()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
