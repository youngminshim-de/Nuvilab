//
//  HomeViewModel.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading
    @Published var searchText: String = ""
    
    var bookList: [BookInformationModel] = []
    var filteredBookList: [BookInformationModel] {
        guard !searchText.isEmpty else { return bookList }
        
        return bookList.filter { book in
            book.bookName.lowercased().contains(searchText.lowercased())
        }
    }
    
    var page: Int = 1
    var isLastPage: Bool = false
    
    private var searchBookAPI: SearchBookAPI
    
    init(searchBookAPI: SearchBookAPI) {
        self.searchBookAPI = searchBookAPI
    }
    
    func onAppearOnce() {
        fetchInitial()
    }
    
    func fetchInitial() {
        Task { await fetchBookList() }
    }
    
    func fetchMore(with book: BookInformationModel) {
        guard !isLastPage,
              book.id == bookList.last?.id else { return }
        page += 1
        Task { await fetchMoreList() }
    }
}

// HomeViewModel + APIs
@MainActor
extension HomeViewModel {
    func fetchBookList() async {
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
            if bookList.count >= data.totalCount ?? Int.max { isLastPage = true }
        } catch (let error) {
            print(error)
        }
    }
    
    func fetchMoreList() async {
        contentState = .fetchMore
        
        defer { contentState = .fetchFinished }
        
        do {
            guard let data = try await searchBookAPI.bookList(pageNo: page),
                  let items = data.items else {
                isLastPage = true
                return
            }
            
            bookList += items
        } catch (let error) {
            print(error)
        }
    }
}

extension HomeViewModel {
    enum ContentState {
        case loading
        case empty
        case fetchFinished
        case fetchMore
    }
}
