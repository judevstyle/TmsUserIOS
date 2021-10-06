//
//  GetRoomChatCustomerUseCase.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation
import Combine

protocol GetRoomChatCustomerUseCase {
    func execute(request: GetRoomChatCustomerRequest) -> AnyPublisher<GetRoomChatCustomerResponse?, Error>
}

struct GetRoomChatCustomerUseCaseImpl: GetRoomChatCustomerUseCase {
    
    private let repository: ConversationRepository
    
    init(repository: ConversationRepository = ConversationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetRoomChatCustomerRequest) -> AnyPublisher<GetRoomChatCustomerResponse?, Error> {
        return self.repository
            .getRoomChatCustomer(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
