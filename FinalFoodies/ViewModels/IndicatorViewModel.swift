//
//  IndicatorViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 5/19/23.
//

import Foundation
import SwiftUI

protocol ActivityIndicatorProtocol: AnyObject {
    var isLoading: Bool { get set }
    func performAsyncTask() async
}

enum LongRunningTaskError: Error {
    case generalError
}
@MainActor
class ActivityIndicatorViewModel: ObservableObject, ActivityIndicatorProtocol {
    @Published var isLoading: Bool = false
    
    func performAsyncTask() async {
        isLoading = true
        do {
            try await performLongRunningTask()
        } catch {
            print("An error occurred: \(error.localizedDescription)")
            // Here you can add additional error handling logic,
            // for example, you could add an error state to your view model
        }
        isLoading = false
    }

    
    private func performLongRunningTask() async throws {
        // Simulate a long running task that might throw an error
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // sleep for 2 seconds
        
        // Let's simulate that an error can occur here
        let errorOccurred = Bool.random()
        if errorOccurred {
            throw LongRunningTaskError.generalError
        }
    }

}


