//
//  SearchBookAPI.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation
import Moya

let SERVICE_KEY = "Zx2bpk0N/toY3ClPpUISRBSwPr1R8FQAzXmarQkqlzjkUoTomM11gJKFPLWKDNdwu49RBZ2ALg/SlnsNrOyA+Q=="

final class SearchBookAPI {
    private let provider: MoyaProvider<SearchBookEndpoint>
    
    init(provider: MoyaProvider<SearchBookEndpoint>) {
        self.provider = provider
    }
    
    func bookList(pageNo: Int,
                  numOfRows: Int = 30) async throws -> BookResponseModel? {
        try await provider.request(.bookList(pageNo: pageNo,
                                             numOfRows: numOfRows))
    }
}

enum SearchBookEndpoint: TargetType {
    case bookList(pageNo: Int,
                  numOfRows: Int)
    
    var baseURL: URL {
        return URL(string: "https://apis.data.go.kr/4050000/libebook")!
    }

    var path: String {
        switch self {
        case .bookList: "/getLibebook"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .bookList: .get
        }
    }
    
    var task: Task {
        switch self {
        case let .bookList(pageNo, numOfRows):
            return .requestParameters(parameters: ["serviceKey": SERVICE_KEY,
                                                   "pageNo": pageNo,
                                                   "numOfRows": numOfRows],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
