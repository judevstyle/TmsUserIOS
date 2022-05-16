//
//  ThaibulkSMSRepository.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 16/5/2565 BE.
//

import Foundation
import Combine
import Moya

protocol ThaibulkSMSRepository {
    func requestOTP(request: OTPRequest) -> AnyPublisher<OTPResponse, Error>
    func verifyOTP(request: OTPRequest) -> AnyPublisher<OTPResponse, Error>
}

final class ThaibulkSMSRepositoryImpl: TMS_USER.ThaibulkSMSRepository {
    private let provider: MoyaProvider<ThaibulkSMSAPI> = MoyaProvider<ThaibulkSMSAPI>()
    
    func requestOTP(request: OTPRequest) -> AnyPublisher<OTPResponse, Error> {
        return self.provider
            .cb
            .request(.requestOTP(request: request))
            .map(OTPResponse.self)
    }
    
    func verifyOTP(request: OTPRequest) -> AnyPublisher<OTPResponse, Error> {
        return self.provider
            .cb
            .request(.verifyOTP(request: request))
            .map(OTPResponse.self)
    }
    
}
