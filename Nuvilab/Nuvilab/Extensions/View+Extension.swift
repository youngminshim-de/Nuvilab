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
    
    func alert(with error: Binding<SearchBookError?>) -> some View {
        self.modifier(ErrorAlertModifier(error: error))
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

struct ErrorAlertModifier: ViewModifier {
    @Binding var error: SearchBookError?
    
    var isPresented: Binding<Bool> {
        Binding {
            error != nil
        } set: { _ in
            error = nil
        }
    }
    
    func body(content: Content) -> some View {
        content
            .alert("",
                   isPresented: isPresented,
                   presenting: error) { error in
                
            } message: { error in
                Text(error.displayErrorMessage)
            }
    }
}
