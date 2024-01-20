//
//  PromptsViewMode.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 1/18/24.
//


import Foundation
import SwiftUI

enum PromptError: Error, Identifiable {
    var id: String { localizedDescription }
    case generationFailed(String)
    case other(Error)
}

@MainActor
class PromptsViewModel: ObservableObject {
    
    @Published var response: String = ""
    @Published var isLoading: Bool = false
    @Published var error: PromptError?
    
    private let chatGPTService: ChatGPTServiceProtocol
     var cityPrompts: [String: String] // Dictionary to store city prompts

    init(chatGPTService: ChatGPTServiceProtocol = ChatGPTService()) {
        self.chatGPTService = chatGPTService
        // Initialize cityPrompts with specific city-based food prompts
        self.cityPrompts = [
                "Atlanta": "Iconic dishes in Atlanta",
                "Marietta": "Historic dining in Marietta",
                "Alpharetta": "Fine dining in Alpharetta",
                "Roswell": "Culinary experience in Roswell",
                "Sandy Springs": "Upscale restaurants in Sandy Springs",
                "Johns Creek": "Family-friendly eateries in Johns Creek",
                "Smyrna": "Popular cafes in Smyrna",
                "Dunwoody": "Dining near Perimeter Mall in Dunwoody",
                "East Point": "Local eats in East Point",
                "Kennesaw": "Eating out in Kennesaw",
                "Decatur": "Trendy restaurants in Decatur",
                "Norcross": "Cultural food in Norcross",
                "Douglasville": "Comfort food in Douglasville",
                "Mableton": "Best diners in Mableton",
                "Peachtree City": "Casual dining in Peachtree City",
                "Peachtree Corners": "Business lunch spots in Peachtree Corners",
                "Brookhaven": "Eateries in Brookhaven",
                "Stonecrest": "Restaurants near Mall at Stonecrest",
                "Tucker": "Local favorites in Tucker",
                "Lawrenceville": "Historic Lawrenceville dining",
                "Milton": "Countryside restaurants in Milton",
                "Woodstock": "Dining in downtown Woodstock",
                "Acworth": "Lakeside dining in Acworth",
                "Hiram": "Family restaurants in Hiram",
                "Fayetteville": "Eating out in Fayetteville",
                "Snellville": "Popular Snellville eateries",
                "Suwanee": "Dining in Suwanee",
                "College Park": "Restaurants near the airport in College Park",
                "Austell": "Dining options in Austell",
                "Powder Springs": "Local Powder Springs cuisine",
                "Fairburn": "Eating in Fairburn",
                "Duluth": "Artistic cafes in Duluth",
                "Stockbridge": "Cozy dining in Stockbridge",
                "Union City": "Union City's best restaurants",
                "Lilburn": "Cultural food scene in Lilburn",
                "Doraville": "International cuisine in Doraville",
                "Chamblee": "Unique eats in Chamblee",
                "Forest Park": "Diverse dining in Forest Park",
                "Villa Rica": "Historic Villa Rica restaurants",
                "Conyers": "Conyers dining experience",
                "Covington": "Film-inspired eateries in Covington",
                "Loganville": "Community dining in Loganville",
                "Palmetto": "Rural culinary delights in Palmetto",
                "Monroe": "Artsy cafes in Monroe",
                "McDonough": "Dining in McDonough",
                "Jonesboro": "Gastronomy in historic Jonesboro",
                "Newnan": "Antebellum dining in Newnan",
                "Griffin": "Griffin's culinary scene",
                "Buford": "Eating near Mall of Georgia in Buford",
                "Clarkston": "Clarkston's diverse food options",
                "Stone Mountain": "Eateries around Stone Mountain",
                "Winder": "Downtown Winder dining",
                // Add other cities as needed
            ]
    }

    func generateResponseForCity(city: String) async {
        await generateResponse(forCity: city)
    }
    
    private    func generateResponse(forCity city: String) async {
        logGenerationStart(for: city)
        guard let prompt = cityPrompts[city] else {
            self.error = .generationFailed("No prompt found for \(city)")
            return
        }
        await performGeneration(withPrompt: prompt)
    }

    private func logGenerationStart(for scannedText: String) {
        print("Generating response for city: \(scannedText)")
    }
    
    private func performGeneration(withPrompt prompt: String) async {
        isLoading = true
        error = nil
        print("Prompt: \(prompt)")
        
        do {
            let generatedResponse = try await chatGPTService.generateResponse(for: prompt)
            print("Response received: \(generatedResponse)")
            if generatedResponse.isEmpty {
                self.error = .generationFailed("Failed to generate response for \(prompt).")
                print("Error: \(self.error?.localizedDescription ?? "Unknown error")")
            } else {
                response = generatedResponse
                print("Response updated")
            }
        } catch let catchedError {
            self.error = .other(catchedError)
            print("Error: \(catchedError.localizedDescription)")
        }
        isLoading = false
        print("Is Loading: \(isLoading)")
    }
}

