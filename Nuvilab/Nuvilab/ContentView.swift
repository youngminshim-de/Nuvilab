//
//  ContentView.swift
//  Nuvilab
//
//  Created by 심영민 on 12/2/24.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView(viewModel: HomeViewModel(
            searchBookAPI: SearchBookAPI(provider: .create())))
    }
}

#Preview {
    ContentView()
}
