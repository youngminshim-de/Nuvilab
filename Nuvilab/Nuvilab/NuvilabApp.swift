//
//  NuvilabApp.swift
//  Nuvilab
//
//  Created by 심영민 on 12/2/24.
//

import SwiftUI

@main
struct NuvilabApp: App {
    init() {
        NetworkConnectionManager.shared.startMonitoring()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
