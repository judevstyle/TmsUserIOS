//
//  PostMessageUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation
import Combine

protocol PostMessageUseCase {
    func execute(request: PostMessageRequest) -> AnyPublisher<PostMessageResponse?, Error>
}

struct PostMessageUseCaseImpl: PostMessageUseCase {
    
    private let repository: ConversationRepository
    
    init(repository: ConversationRepository = ConversationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostMessageRequest) -> AnyPublisher<PostMessageResponse?, Error> {
        return self.repository
            .sendMessage(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
