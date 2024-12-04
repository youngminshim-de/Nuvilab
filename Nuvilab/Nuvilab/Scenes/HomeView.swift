//
//  HomeView.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            contentViewBuilder
        }
        .padding(.horizontal, 16)
        .environmentObject(viewModel)
        .onAppearOnce { viewModel.onAppearOnce() }
        .searchable(text: $viewModel.searchText, prompt: "도서명 검색")
        .alert(with: $viewModel.apiError)
    }
    
    @ViewBuilder
    var contentViewBuilder: some View {
        switch viewModel.contentState {
        case .loading:
            CenterAlignedProgressView()
        case .empty:
            EmptySearchView()
        case .fetchFinished, .fetchMore:
            SearchResultView()
        }
    }
}

//#Preview {
//    HomeView()
//}


