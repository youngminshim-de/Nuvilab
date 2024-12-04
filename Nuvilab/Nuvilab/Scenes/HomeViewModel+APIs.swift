//
//  HomeViewModel+APIs.swift
//  Nuvilab
//
//  Created by 심영민 on 12/4/24.
//

import Foundation

// HomeViewModel + APIs
@MainActor
extension HomeViewModel {
    func fetchFromAPI() async {
        contentState = .loading
        
        defer {
            if contentState != .empty { contentState = .fetchFinished }
        }
        
        do {
            guard let data = try await searchBookAPI.bookList(pageNo: page),
                let items = data.items else {
                contentState = .empty
                return
            }
            bookList = items
            persistenceManager.saveBooks(bookList)
        } catch (let error) {
            /// 2. 재시도를 하고 난 이후에도 에러가 발생한다면 비정상 종료를 시키는 게 아니라 에러 핸들링을 통해 사용자에게 알린다.
            guard let error = error as? SearchBookError else {
                apiError = .unknown
                return
            }
            apiError = error
            /// 3. Alert를 띄워 Error가 발생했음을 알리고, Core Data Fetch를 통해 오프라인 모드로 동작하게 한다.
            fetchFromCoreData()
        }
    }
    
    func fetchMoreFromAPI() async {
        contentState = .fetchMore
        
        defer { contentState = .fetchFinished }
        
        do {
            guard let data = try await searchBookAPI.bookList(pageNo: page),
                  let items = data.items else {
                isLastPage = true
                return
            }
            
            bookList += items
            persistenceManager.saveBooks(items)
            
            if bookList.count >= data.totalCount ?? Int.max { isLastPage = true }
        } catch (let error) {
            guard let error = error as? SearchBookError else {
                apiError = .unknown
                return
            }
            apiError = error
            fetchFromCoreData()
        }
    }
}
