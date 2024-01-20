//
//  NetworkViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 1/18/24.
//
import Combine
import Foundation

class NetworkStatusViewModel: ObservableObject {
    @Published var isNetworkAvailable: Bool = false
    private var networkMonitor: NetworkStatusMonitoring
    private var cancellables = Set<AnyCancellable>()
    init(networkMonitor: NetworkStatusMonitoring = NetworkMonitor()) {
        self.networkMonitor = networkMonitor
        self.networkMonitor.startMonitoring()
        setupNetworkStatusListener()
    }
    private func setupNetworkStatusListener() {
            if let monitor = networkMonitor as? NetworkMonitor {
                monitor.$isNetworkAvailable
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.isNetworkAvailable, on: self)
                    .store(in: &cancellables)
            }
        }
    }
