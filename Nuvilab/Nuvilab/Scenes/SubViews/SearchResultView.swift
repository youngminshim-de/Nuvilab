//
//  SearchResultView.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import SwiftUI

/// 이슈 3: 대량의 데이터를 List에 표시 시 성능저하
/// 해결
/// 1. VStack -> LazyStack 으로 변경 (VStack은 화면에 보여지지 않는 Cell까지 모두 처리하는 반면, LazyVStack은 화면에 보여지는 Cell만 처리하여 성능을 향상 시킬 수 있다.)
/// 2. Pagination : Pagination처리를 하여 한번에 모든 데이터를 가져오지 않고, 적당한 Data만을 받아와 UI 성능을 향상 시킬 수 있다.
/// 3. Disappear 이용: 빠르게 스크롤 시, disappear되는 Cell에서 처리되는 작업을 취소시켜 불필요한 작업을 최소화 하여 성능을 향상 시킬 수 있다.
///   (Ex: KingFIsher를 이용하여 Image Download 시, cancelOnDisapper를 이용하여 이미지 다운로드를 취소시켜 성능을 향상 시킬 수 있다.

struct SearchResultView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            /// 1. VStack -> LazyVStack 변경
            LazyVStack(spacing: 8) {
                ForEach(viewModel.filteredBookList) { book in
                    BookListCell(item: book)
                        .onAppear { viewModel.fetchMore(with: book) } /// 2. Pagination
                        .onDisappear { } /// 3. image download와 같은 시간이 오래걸리는 작업을 진행하고 있다면 cancel 시킨다.
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
