//
//  BookResponseModel.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation
/// 이슈 1: URLSession을 사용한 API 요청 시 데이터 변환 오류 발생
/// 해결방법
/// 1. 최우선적으로 앱이 비정상종료 되지 않도록 한다. (프로퍼티 Optional 처리, Default 값 설정 등)
/// 2. UI에 있어 크리티컬한 필드가 아니라면 해당부분을 제외하고, UI를 그린다.
/// 3. 크리티컬한 필드라면 오류메세지를 보여준다.
struct BookResponseModel: Codable {
    let resultCode: Int
    let resultMsg: String
    let numOfRows: Int? /// Optional 처리
    let pageNo: Int?
    let totalCount: Int?
    let items: [BookInformationModel]?
}

struct BookInformationModel: Codable, Identifiable {
    var id: Int
    let genre: String
    let bookName: String
    let authorName: String
    let publisher: String
    let publicationYear: String
    let isLoaned: Bool
    let descriptions: String

    enum CodingKeys: String, CodingKey {
        case id = "no"
        case genre = "gnr"
        case bookName = "ebk_nm"
        case authorName = "aut_nm"
        case publisher = "pblshr"
        case publicationYear = "pblsh_ymd"
        case isLoaned = "loan_avlbl_yn"
        case descriptions = "cn_intro"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decodeIfPresent(Int.self, forKey: .id)) ?? -1 /// Default 값 설정
        self.genre = (try? container.decode(String.self, forKey: .genre)) ?? ""
        self.bookName = (try? container.decode(String.self, forKey: .bookName)) ?? ""
        self.authorName = (try? container.decode(String.self, forKey: .authorName)) ?? ""
        self.publisher = (try? container.decode(String.self, forKey: .publisher)) ?? ""
        self.publicationYear = (try? container.decode(String.self, forKey: .publicationYear)) ?? ""
        
        let _isLoaned = (try? container.decode(String.self, forKey: .isLoaned)) ?? "Y"
        self.isLoaned = _isLoaned == "Y" ? true : false
        
        self.descriptions = (try? container.decode(String.self, forKey: .descriptions)) ?? ""
    }
    // For CoreData
    init(entity: BookInformation) {
        self.id = Int(entity.id)
        self.genre = entity.genre ?? ""
        self.bookName = entity.bookName ?? ""
        self.authorName = entity.authorName ?? ""
        self.publisher = entity.publisher ?? ""
        self.publicationYear = entity.publicationYear ?? ""
        self.isLoaned = entity.isLoaned
        self.descriptions = entity.descriptions ?? ""
    }
}
