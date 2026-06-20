//
//  OpenAIMealGenerationService.swift
//  FinalFoodies / CraveCart
//
//  Adapter that turns the existing ChatGPTService into a meal generator.
//  We depend on `ChatGPTServiceProtocol` (not the concrete class) so the app
//  is not locked to one AI vendor and the adapter is unit-testable with a
//  stub. This reuses the app's existing OpenAI + Keychain + cache plumbing.
//

import Foundation

/// Abstraction over "raw AI call → meal DTOs". Lives at the data boundary.
protocol MealGenerationService {
    func generateMeals(request: CravingRequest) async throws -> [MealOptionDTO]
}

final class OpenAIMealGenerationService: MealGenerationService {
    private let chatGPTService: ChatGPTServiceProtocol
    private let promptBuilder: MealPromptBuilder

    init(
        chatGPTService: ChatGPTServiceProtocol,
        promptBuilder: MealPromptBuilder = MealPromptBuilder()
    ) {
        self.chatGPTService = chatGPTService
        self.promptBuilder = promptBuilder
    }

    func generateMeals(request: CravingRequest) async throws -> [MealOptionDTO] {
        let prompt = promptBuilder.build(for: request)
        let raw = try await chatGPTService.generateResponse(for: prompt)

        guard let data = Self.extractJSONArray(from: raw) else {
            throw CraveCartError.generationFailed("No JSON array in AI response.")
        }

        do {
            return try JSONDecoder().decode([MealOptionDTO].self, from: data)
        } catch {
            throw CraveCartError.generationFailed(error.localizedDescription)
        }
    }

    /// Defensive extraction: the model may wrap JSON in prose or ``` fences.
    /// We grab the substring from the first `[` to the last `]`.
    static func extractJSONArray(from response: String) -> Data? {
        guard
            let start = response.firstIndex(of: "["),
            let end = response.lastIndex(of: "]"),
            start < end
        else {
            return nil
        }
        let slice = response[start...end]
        return String(slice).data(using: .utf8)
    }
}
