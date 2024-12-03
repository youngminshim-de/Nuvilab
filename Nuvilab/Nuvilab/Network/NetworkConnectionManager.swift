//
//  NetworkConnectionManager.swift
//  Nuvilab
//
//  Created by 심영민 on 12/3/24.
//

import Network

final class NetworkConnectionManager {
    static let shared = NetworkConnectionManager()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private(set) var isConnected: Bool = false
    
    init() {
        self.monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
