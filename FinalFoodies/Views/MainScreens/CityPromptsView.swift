//
//  CityPromptsView.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 1/19/24.
//


import SwiftUI

struct CityPromptsView: View {
    @StateObject var viewModel = PromptsViewModel()
    @State private var showResponse = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.cityPrompts.keys.sorted(), id: \.self) { city in
                        Label(city, systemImage: "building.2")
                            .padding()
                            .onTapGesture {
                                Task {
                                    await viewModel.generateResponseForCity(city: city)
                                    showResponse = true
                                }
                            }
                    }
                }
            }
            .navigationTitle("City Prompts")
        }
        .sheet(isPresented: $showResponse) {
            ResponseView(response: viewModel.response, isLoading: viewModel.isLoading, error: viewModel.error)
        }
    }
}

import SwiftUI

struct ResponseView: View {
    let response: String
    let isLoading: Bool
    let error: PromptError?

    var body: some View {
        ScrollView {
            VStack {
                if isLoading {
                    ProgressView()
                } else if let error = error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red) // Red color for errors
                } else {
                    HyperlinkTextView(text: response)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 300, height: 200)
        .padding()
    }
}

// TextView that detects hyperlinks
struct HyperlinkTextView: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.text = text
        textView.textColor = .label // Default text color
        textView.backgroundColor = .clear // To match SwiftUI view's background
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

// Rest of your SwiftUI code


#Preview {
    CityPromptsView()
}
