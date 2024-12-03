//
//  CenterAlignedProgressView.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import SwiftUI

struct CenterAlignedProgressView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ProgressView().scaleEffect(2)
            Spacer()
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
    }
}

#Preview {
    CenterAlignedProgressView()
}
