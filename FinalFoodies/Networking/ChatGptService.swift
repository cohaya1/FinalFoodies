//
//  ChatGptService.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 1/18/24.
//




import Foundation
import OpenAI
import Network
// Define a protocol for your service
protocol ChatGPTServiceProtocol {
    func generateResponse(for prompt: String) async throws -> String
}

class ChatGPTService: ChatGPTServiceProtocol {
    
    private let openAI: OpenAI
    private var cache: [String: String] = [:]  // A dictionary to store cached responses
    private let persistentCache: PersistentCache  // For persistent caching
    private let networkMonitor: NetworkMonitor  // To monitor network conditions
    init() {
            // Retrieve the API token from Keychain
        let tokenManager = TokenManager()
                guard let apiToken = tokenManager.retrieveApiToken() else {
                    fatalError("API token not found in Keychain")
                }
            
            let configuration = OpenAI.Configuration(token: apiToken)
            self.openAI = OpenAI(configuration: configuration)
            self.persistentCache = PersistentCache()
            self.networkMonitor = NetworkMonitor()
        }
            
            func generateResponse(for prompt: String) async throws -> String {
                print("generateResponse called with prompt: \(prompt)")

                // Check in-memory cache first
                if let cachedResponse = cache[prompt] {
                    return cachedResponse
                }

                // Check persistent cache
                if let cachedResponse = persistentCache.getResponse(for: prompt) {
                    return cachedResponse
                }

                // Handle network conditions
//                guard networkMonitor.isNetworkAvailable else {
//                    // Handle logic for no network or poor network conditions
//                    return "Network unavailable. Please try again later."
//                }

                print("Sending request to OpenAI API.")

                let query = ChatQuery(
                    model: .gpt4_1106_preview,
                    messages: [.init(role: .user, content: prompt)]
                )

                do {
                    let result = try await openAI.chats(query: query)
                    if let response = result.choices.first?.message.content {
                        print("Received response from OpenAI API: \(response)")
                        
                        // Store in both caches
                        cache[prompt] = response
                        persistentCache.storeResponse(response, for: prompt)
                        
                        return response
                    } else {
                        print("Received an empty response from OpenAI API.")
                        return ""
                    }
                } catch let error {
                    print("Error occurred: \(error.localizedDescription)")
                    // Implement retry logic here if needed
                    throw error
                }
            }
        }

class PersistentCache {
    private let userDefaults = UserDefaults.standard

    private func hashKey(for prompt: String) -> String {
         return String(prompt.hashValue)
     }

     func getResponse(for prompt: String) -> String? {
         let key = hashKey(for: prompt)
         return userDefaults.string(forKey: key)
     }

    func storeResponse(_ response: String, for prompt: String) {
        DispatchQueue.global(qos: .background).async {
            let key = self.hashKey(for: prompt)
            self.userDefaults.set(response, forKey: key)
        }
    }

}



protocol NetworkStatusMonitoring {
    var isNetworkAvailable: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

class NetworkMonitor: NetworkStatusMonitoring {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    @Published private(set) var isNetworkAvailable: Bool = false

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

