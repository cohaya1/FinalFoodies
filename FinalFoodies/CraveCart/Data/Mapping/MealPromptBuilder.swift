//
//  MealPromptBuilder.swift
//  FinalFoodies / CraveCart
//
//  Builds the structured prompt sent to the AI. Keeping prompt construction
//  out of the service/ViewModel makes it independently testable and easy to
//  iterate on. The prompt pins the JSON contract that MealOptionDTO decodes.
//

import Foundation

struct MealPromptBuilder {
    func build(for request: CravingRequest) -> String {
        let budgetLine: String
        if let budget = request.budget {
            budgetLine = "Total budget: $\(budget)."
        } else {
            budgetLine = "No strict budget, but keep it cheap."
        }

        let pantryLine = request.pantryItems.isEmpty
            ? "The user has no pantry items to reuse."
            : "Already in the pantry (reduce cost by using these): \(request.pantryItems.joined(separator: ", "))."

        return """
        You are CraveCart, a budget meal assistant. The user is craving: "\(request.text)".
        \(budgetLine)
        Servings: \(request.servings). Effort level: \(request.effortLevel.label).
        \(pantryLine)

        Return EXACTLY 3 meal options as a JSON array, one for each pathType in this
        order: "cookItCheap", "lazyGrocery", "pickupAlternative". Respond with ONLY the
        JSON array, no prose, no markdown fences.

        Each object must have these keys:
        {
          "pathType": "cookItCheap" | "lazyGrocery" | "pickupAlternative",
          "title": String,
          "estimatedTotalCost": Number,
          "estimatedCostPerServing": Number,
          "estimatedSavings": Number,
          "timeMinutes": Number,
          "ingredients": [String],
          "steps": [String]
        }

        Prefer cheaper, realistic options over trendy expensive ones. Do not invent
        exact prices; use reasonable regional estimates. No medical claims.
        """
    }
}
