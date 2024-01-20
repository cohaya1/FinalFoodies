//
//  utils.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 1/19/24.
//

import KeychainSwift

class TokenManager {
    private let keychain = KeychainSwift()
    private let tokenKey = "OPENAI_API_TOKEN"  // Key to store the token in Keychain

    // Store API token
    func storeApiToken(token: String) {
        let success = keychain.set(token, forKey: tokenKey)
        if !success {
            // Handle the error, e.g., log it or inform the user
            print("Error: Failed to store API token in Keychain")
        }
    }

    // Retrieve API token
    func retrieveApiToken() -> String? {
        return keychain.get(tokenKey)
    }

    // Delete API token
    func deleteApiToken() {
        let success = keychain.delete(tokenKey)
        if !success {
            // Handle the error, e.g., log it or inform the user
            print("Error: Failed to delete API token from Keychain")
        }
    }

    // Check if the API token exists
    func hasApiToken() -> Bool {
        return keychain.get(tokenKey) != nil
    }
}

//// Usage
//let tokenManager = TokenManager()
//
//// Storing a token
//tokenManager.storeApiToken(token: "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", forKey: "OpenAIAPIToken")
//
//// Retrieving a token
//if let token = tokenManager.retrieveApiToken(forKey: "OpenAIAPIToken") {
//    // Use the token
//} else {
//    // Handle the case where token is not available
//}
//
//// Deleting a token
//tokenManager.deleteApiToken(forKey: "OpenAIAPIToken")
//
//// Checking for token existence
//if tokenManager.hasToken(forKey: "OpenAIAPIToken") {
//    // Token exists
//} else {
//    // Token does not exist
//}
//
