//
//  NetworkLoggerPlugin.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation
import Moya

final class NetworkLoggerPlugin: PluginType {
    var startDate: Date?

    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType) {
        startDate = Date()

        let url = request.request?.url?.absoluteString ?? ""
        let header = data(from: request.request?.allHTTPHeaderFields)?.prettyJSON ?? "{}"
        let body = (request.request?.httpBody ?? Data()).prettyJSON ?? "{}"
        let message = """

        ---------------------------------------------------------------------------------------------------------------------------
        👉🏻 REQUEST (\(request.request?.method?.rawValue ?? "Uknown")) (\(target))
        ---------------------------------------------------------------------------------------------------------------------------
        • URL             : \(url.removingPercentEncoding ?? "")
        • TARGET          : \(target)
        • HEADER          :
        \(header)
        • BODY            :
        \(body)
        ---------------------------------------------------------------------------------------------------------------------------
        👉🏻 END (\(target))
        ---------------------------------------------------------------------------------------------------------------------------

        """
        #if DEBUG
        print(message)
        #endif
    }

    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        let executionTime = Int(Date().timeIntervalSince(startDate ?? Date()) * 1_000) // ms
        var message: String

        switch result {
        case let .success(response):
            let request = response.request
            let url = request?.url?.absoluteString ?? ""
            let statusCode = response.statusCode
            let responseData = response.data.prettyJSON ?? ""
            message = """

            ---------------------------------------------------------------------------------------------------------------------------
            👈🏻 RESPONSE (\(target))
            ---------------------------------------------------------------------------------------------------------------------------
            • URL             : \(url.removingPercentEncoding ?? "")
            • TARGET          : \(target)
            • STATUS CODE     : \(statusCode)
            • TIME            : \(executionTime) ms
            • RESPONSE DATA   :
            \(responseData)
            ---------------------------------------------------------------------------------------------------------------------------
            👈🏻 END (\(target))
            ---------------------------------------------------------------------------------------------------------------------------

            """
            #if DEBUG
            print(message)
            #endif
            break
        case let .failure(error):
            let statusCode = error.errorCode
            let reason = error.failureReason ?? error.errorDescription ?? "unknown error"
            message = """

            ---------------------------------------------------------------------------------------------------------------------------
            🚫 ERROR RESPONSE (\(target))
            ---------------------------------------------------------------------------------------------------------------------------
            • TARGET          : \(target)
            • STATUS CODE     : \(statusCode)
            • ERROR REASON    : \(reason)
            ---------------------------------------------------------------------------------------------------------------------------
            🚫 ERROR END (\(target))
            ---------------------------------------------------------------------------------------------------------------------------

            """
            #if DEBUG
            print(message)
            #endif
            break
        }
    }
}

extension NetworkLoggerPlugin {
    private func data(from dictionary: [String: String]?) -> Data? {
        guard let dictionary,
              let data = try? JSONEncoder().encode(dictionary)
        else {
            return nil
        }

        return data
    }
}
