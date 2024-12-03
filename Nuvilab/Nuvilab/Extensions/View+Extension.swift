//
//  View+Extension.swift
//  Nuvilab
//
//  Created by 심영민 on 12/4/24.
//

import SwiftUI

// MARK: Extension
extension View {
    func onAppearOnce(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewAppearOnceModifier(action: action))
    }
}

// MARK: Modifier

struct ViewAppearOnceModifier: ViewModifier {
    @State private var onAppearOnce = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content.onAppear {
            if onAppearOnce == false {
                onAppearOnce = true
                action?()
            }
        }
    }
}
