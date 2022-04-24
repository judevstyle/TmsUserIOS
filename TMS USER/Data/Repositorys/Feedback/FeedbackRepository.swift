//
//  FeedbackRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 24/4/2565 BE.
//

import Foundation
import Combine
import Moya

protocol FeedbackRepository {
    func createFeedback(request: PostCreateFeedbackRequest) -> AnyPublisher<PostCreateFeedbackResponse, Error>
}

final class FeedbackRepositoryImpl: TMS_USER.FeedbackRepository {
    private let provider: MoyaProvider<FeedbackAPI> = MoyaProvider<FeedbackAPI>()
    
    func createFeedback(request: PostCreateFeedbackRequest) -> AnyPublisher<PostCreateFeedbackResponse, Error> {
        return self.provider
            .cb
            .request(.createFeedback(request: request))
            .map(PostCreateFeedbackResponse.self)
    }
    
}
