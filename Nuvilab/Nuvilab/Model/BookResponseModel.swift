//
//  BookResponseModel.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation

struct BookResponseModel: Codable {
    let resultCode: Int
    let resultMsg: String
    let numOfRows: Int?
    let pageNo: Int?
    let totalCount: Int?
    let items: [BookInformationModel]?
}

struct BookInformationModel: Codable, Identifiable {
    let id = UUID()
    let no: Int?
    let genre: String
    let bookName: String
    let authorName: String
    let publisher: String
    let publicationYear: String
    let isLoaned: Bool
    let description: String

    enum CodingKeys: String, CodingKey {
        case no
        case genre = "gnr"
        case bookName = "ebk_nm"
        case authorName = "aut_nm"
        case publisher = "pblshr"
        case publicationYear = "pblsh_ymd"
        case isLoaned = "loan_avlbl_yn"
        case description = "cn_intro"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.no = try container.decodeIfPresent(Int.self, forKey: .no)
        self.genre = (try? container.decode(String.self, forKey: .genre)) ?? ""
        self.bookName = (try? container.decode(String.self, forKey: .bookName)) ?? ""
        self.authorName = (try? container.decode(String.self, forKey: .authorName)) ?? ""
        self.publisher = (try? container.decode(String.self, forKey: .publisher)) ?? ""
        self.publicationYear = (try? container.decode(String.self, forKey: .publicationYear)) ?? ""
        
        let _isLoaned = (try? container.decode(String.self, forKey: .isLoaned)) ?? "Y"
        self.isLoaned = _isLoaned == "Y" ? true : false
        
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
    }
}
