//
//  MoyaProvider.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation
import Moya

extension MoyaProvider {
    static func create<T: TargetType>() -> MoyaProvider<T> {
        return MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
    }
    
    static func createForMock<T: TargetType>(statusCode: Int = 200) -> MoyaProvider<T> {
        let endpointClosure = { (target: T) -> Endpoint in
            Endpoint(url: URL(target: target).absoluteString,
                     sampleResponseClosure: {.networkResponse(statusCode, target.sampleData)},
                     method: target.method,
                     task: target.task,
                     httpHeaderFields: target.headers)
        }
        
        return MoyaProvider<T>(endpointClosure: endpointClosure,
                               stubClosure: MoyaProvider<T>.immediatelyStub,
                               plugins: [NetworkLoggerPlugin()])
    }
    
    func request<T: Decodable>(_ target: Target) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let decoded: T = try filteredResponse.map(T.self)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: self.mapToCustomError(with: error))
                    }
                    
                case let .failure(error):
                    continuation.resume(throwing: self.mapToCustomError(with: error))
                }
            }
        }
    }
    
    /// 사전에 정의된 에러를 커스텀 에러로 변환
    private func mapToCustomError(with error: Error) -> SearchBookError {
        if let moyaError = error as? MoyaError {
            return .moyaError(moyaError)
        } else {
            return .customError
        }
    }
}

