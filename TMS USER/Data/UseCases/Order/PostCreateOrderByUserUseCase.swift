//
//  PostCreateOrderByUserUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation
import Combine

protocol PostCreateOrderByUserUseCase {
    func execute(request: PostCreateOrderByUserRequest) -> AnyPublisher<PostCreateOrderByUserResponse?, Error>
}

struct PostCreateOrderByUserUseCaseImpl: PostCreateOrderByUserUseCase {
    
    private let repository: OrderRepository
    
    init(repository: OrderRepository = OrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostCreateOrderByUserRequest) -> AnyPublisher<PostCreateOrderByUserResponse?, Error> {
        return self.repository
            .createOrderByUser(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
