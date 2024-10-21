//
//  ImageLoader.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 06.09.2024.
//

import SwiftUI
import Network

struct ImageLoader: View {
    var url: URL?
    
    @State private var image: UIImage? = nil
    @State private var errorOccurred = false
    @State private var isConnected: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if errorOccurred {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3)
                    Text("Error")
                        .font(.title3.bold())
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if !isConnected {
                VStack {
                    Image(systemName: "wifi.exclamationmark")
                        .font(.largeTitle)
                    Text("No Internet")
                        .font(.title3.bold())
                }
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ProgressView()
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onAppear {
            if image == nil {
                monitorNetwork()
                loadImage()
            }
        }
        .onDisappear {
            monitor.cancel()
        }
    }
    
    private func loadImage() {
        guard let url = url else {
            errorOccurred = true
            return
        }

        errorOccurred = false
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let uiImage = UIImage(data: data) {
                    image = uiImage
                } else {
                    errorOccurred = true
                }
            }
        }
        
        task.resume()
    }
    
    private func monitorNetwork() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                if self.isConnected && image == nil {
                    loadImage()
                }
            }
        }
        monitor.start(queue: queue)
    }
}

#Preview {
    VStack {
        ImageLoader(url: nil)
    }
}
