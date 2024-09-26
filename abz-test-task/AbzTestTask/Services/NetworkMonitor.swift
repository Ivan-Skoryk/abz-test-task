//
//  NetworkMonitor.swift
//  abz-test-task
//
//  Created by Ivan Skoryk on 26.09.2024.
//

import SwiftUI
import Network

/// An enum representing the network connection status.
///
/// Each case corresponds to a possible state of the network connection.
enum NetworkStatus: String {
    case connected
    case disconnected
}

/// A class that monitors the network connectivity status.
///
/// This class conforms to `ObservableObject`, allowing SwiftUI views to react to changes in network status.
final class NetworkMonitor: ObservableObject {
    private var monitor: NWPathMonitor?  // The network path monitor
    private let queue = DispatchQueue(label: "NetworkMonitor")  // Queue for monitoring network status
    
    @Published var isDisconnected = false  // Published property to notify subscribers of network status changes
    
    /// Initializes the network monitor and starts checking the connection status.
    init() {
        checkConnection()
    }
    
    /// Starts the network monitoring process and updates the isDisconnected property based on the network status.
    func checkConnection() {
        monitor = NWPathMonitor()  // Create a new NWPathMonitor instance
        monitor?.pathUpdateHandler = { [weak self] path in  // Update handler for path changes
            guard let self = self else { return }  // Avoid retain cycles
            
            DispatchQueue.main.async {
                self.isDisconnected = path.status != .satisfied  // Update isDisconnected based on the path status
            }
        }
        monitor?.start(queue: queue)  // Start monitoring on the specified queue
    }
    
    /// Stops monitoring the network status.
    func stopMonitoring() {
        monitor?.cancel()  // Cancel the network monitor
        monitor = nil  // Release the monitor
    }
}
