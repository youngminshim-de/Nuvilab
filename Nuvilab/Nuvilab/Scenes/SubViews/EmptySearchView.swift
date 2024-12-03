//
//  EmptySearchView.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import SwiftUI

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("결과 없음")
                .font(.largeTitle.bold())
        }
    }
}

#Preview {
    EmptySearchView()
}
