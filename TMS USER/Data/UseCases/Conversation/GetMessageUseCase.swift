//
//  GetMessageUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/28/21.
//

import Foundation
import Combine

protocol GetMessageUseCase {
    func execute(request: GetMessageRequest) -> AnyPublisher<GetMessageResponse?, Error>
}

struct GetMessageUseCaseImpl: GetMessageUseCase {
    
    private let repository: ConversationRepository
    
    init(repository: ConversationRepository = ConversationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetMessageRequest) -> AnyPublisher<GetMessageResponse?, Error> {
        return self.repository
            .getMessage(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
