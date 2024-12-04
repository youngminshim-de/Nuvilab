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
            guard let error = error as? SearchBookError else {
                apiError = .unknown
                return
            }
            apiError = error
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
