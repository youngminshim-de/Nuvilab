//
//  Interceptor.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation
import Moya
import Alamofire

/// 이슈 2: 네트워크 연결 불안정 시 앱의 비정상 종료
/// 해결
/// 1. 지수 백오프 알고리즘을 이용하여 재시도 한다.

final class Interceptor: RequestInterceptor {
    private let retryLimit: UInt
    private let exponentialBackoffBase: UInt
    private let exponentialBackoffScale: Double
    private let retryPolicy: RetryPolicy
    
    /// retryLimit = 2, delayTime: 3sec
    /// 설정이유 : 무분별한 재시도를 막고 (비용, 리소스 낭비) UX 경험 측면에서 3초이상 아무런 액션이 없으면 이탈률이 높기 때문에
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
