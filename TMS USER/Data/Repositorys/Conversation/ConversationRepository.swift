//
//  ConversationRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/28/21.
//

import Foundation
import Combine
import Moya

protocol ConversationRepository {
    func getRoomChatCustomer(request: GetRoomChatCustomerRequest) -> AnyPublisher<GetRoomChatCustomerResponse, Error>
    func getMessage(request: GetMessageRequest) -> AnyPublisher<GetMessageResponse, Error>
    func sendMessage(request: PostMessageRequest) -> AnyPublisher<PostMessageResponse, Error>
}

final class ConversationRepositoryImpl: TMS_USER.ConversationRepository {
    private let provider: MoyaProvider<ConversationAPI> = MoyaProvider<ConversationAPI>()
    
    func getMessage(request: GetMessageRequest) -> AnyPublisher<GetMessageResponse, Error> {
        return self.provider
            .cb
            .request(.getMessage(request: request))
            .map(GetMessageResponse.self)
    }
    
    func getRoomChatCustomer(request: GetRoomChatCustomerRequest) -> AnyPublisher<GetRoomChatCustomerResponse, Error> {
        return self.provider
            .cb
            .request(.getRoomChatCustomer(request: request))
            .map(GetRoomChatCustomerResponse.self)
    }
    
    func sendMessage(request: PostMessageRequest) -> AnyPublisher<PostMessageResponse, Error> {
        return self.provider
            .cb
            .request(.sendMessage(request: request))
            .map(PostMessageResponse.self)
    }
}
