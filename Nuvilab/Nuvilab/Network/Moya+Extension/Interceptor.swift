//
//  Interceptor.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation
import Moya
import Alamofire

final class Interceptor: RequestInterceptor {
    private let retryLimit: UInt
    private let exponentialBackoffBase: UInt
    private let exponentialBackoffScale: Double
    private let retryPolicy: RetryPolicy
    
    init(retryLimit: UInt = 2,
         exponentialBackoffBase: UInt = 2,
         exponentialBackoffScale: Double = 1) {
        self.retryLimit = retryLimit
        self.exponentialBackoffBase = exponentialBackoffBase
        self.exponentialBackoffScale = exponentialBackoffScale
        self.retryPolicy = RetryPolicy(retryLimit: retryLimit, exponentialBackoffBase: exponentialBackoffBase, exponentialBackoffScale: exponentialBackoffScale)
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        if request.retryCount < retryPolicy.retryLimit,
           retryPolicy.shouldRetry(request: request, dueTo: error) {
            let timeDelay = exponentialTimeDelay(request)
             completion(.retryWithDelay(timeDelay))
         } else {
             completion(.doNotRetry)
         }
    }
    
    private func exponentialTimeDelay(_ request: Request) -> Double {
        return pow(Double(retryPolicy.exponentialBackoffBase), Double(request.retryCount)) * retryPolicy.exponentialBackoffScale
    }
}
