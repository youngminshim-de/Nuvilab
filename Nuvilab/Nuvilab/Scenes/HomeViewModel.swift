//
//  HomeViewModel.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation
import CoreData

final class HomeViewModel: ObservableObject {
    /// Published
    @Published var contentState: ContentState = .loading
    @Published var searchText: String = ""
    
    /// CoreData
    let persistenceManager = PersistenceManager.shared
    
    /// For API
    let searchBookAPI: SearchBookAPI
    var page: Int = 1
    var isLastPage: Bool = false
    
    /// For UI
    var bookList: [BookInformationModel] = []
    var filteredBookList: [BookInformationModel] {
        guard !searchText.isEmpty else { return bookList }
        
        return bookList.filter { book in
            book.bookName.lowercased().contains(searchText.lowercased())
        }
    }
    
    init(searchBookAPI: SearchBookAPI) {
        self.searchBookAPI = searchBookAPI
    }
    
    func onAppearOnce() { fetchData() }
    
    private func fetchData() {
        if NetworkConnectionManager.shared.isConnected {
            Task { await fetchFromAPI() }
        } else {
            fetchFromCoreData()
        }
    }
    
    func fetchFromCoreData() {
        contentState = .loading
        
        defer {
            if contentState != .empty { contentState = .fetchFinished }
        }
        
        let offset = bookList.count
        let totalCount = persistenceManager.coreDataCount()
        
        bookList += persistenceManager.fetchCoreData(fetchOffset: offset)
        
        if bookList.count >= (totalCount ?? Int.max) { isLastPage = true }
        
        guard !bookList.isEmpty else {
            contentState = .empty
            return
        }
    }
    
    func fetchMore(with book: BookInformationModel) {
        guard !isLastPage,
              book.id == bookList.last?.id else { return }
        
        page += 1
        
        if NetworkConnectionManager.shared.isConnected {
            Task { await fetchMoreFromAPI() }
        } else {
            fetchFromCoreData()
        }
    }
}

// MARK: ContentState
extension HomeViewModel {
    enum ContentState {
        case loading
        case empty
        case fetchFinished
        case fetchMore
    }
}
