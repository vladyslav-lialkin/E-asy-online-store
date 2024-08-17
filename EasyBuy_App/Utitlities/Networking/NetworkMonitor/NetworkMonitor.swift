//
//  NetworkMonitor.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 14.08.2024.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let previousConnectionStatus = self.isConnected
                self.isConnected = path.status == .satisfied

                if self.isConnected && !previousConnectionStatus {
                    NotificationCenter.default.post(name: .didRestoreInternetConnection, object: nil)
                }
            }
        }
        monitor.start(queue: queue)
    }
}

extension Notification.Name {
    static let didRestoreInternetConnection = Notification.Name("didRestoreInternetConnection")
}
