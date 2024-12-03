//
//  SearchResultView.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.filteredBookList) { book in
                    BookListCell(item: book)
                        .onAppear { viewModel.fetchMore(with: book) }
                    Divider()
                }
                if viewModel.contentState == .fetchMore {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    SearchResultView()
}
