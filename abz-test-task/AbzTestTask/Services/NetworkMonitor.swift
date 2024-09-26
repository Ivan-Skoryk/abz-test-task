//
//  NetworkMonitor.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI
import Network

enum NetworkStatus: String {
    case connected
    case disconnected
}

final class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isDiconnected = false
    
    init() {
        checkConnection()
    }
    
    func checkConnection() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isDiconnected = path.status != .satisfied
            }
        }
        monitor?.start(queue: queue)
    }
}
