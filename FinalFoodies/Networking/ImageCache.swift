//
//  ImageCache.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 7/29/23.
//

import Foundation


import SwiftUI
// CacheAsyncImage is a custom View that wraps AsyncImage and provides caching functionality.
// Content is a generic View type, allowing the user to define their custom content based on the image loading phase.


struct CacheAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    // Initialize the CacheAsyncImage with required parameters and a content closure.

    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        
    }

    var body: some View {
        // Check if the image is already cached.

        if let cached = ImageCache[url] {
            let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
            let _ = print("request \(url.absoluteString)")
            // If the image is not cached, load it using AsyncImage and cache it once loaded.

            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    // Cache the image when it's successfully loaded and display the appropriate content based on the phase.

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

struct CacheAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CacheAsyncImage(url: URL(string: Restaurant.sample.restaurantimage?.url ?? "")!)
 { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure(_):
                ProgressView()
            @unknown default:
                fatalError()
            }
        }
    }
}

// ImageCache is a utility class that provides a simple caching mechanism for SwiftUI Images.
fileprivate class ImageCache {
    // A dictionary to store cached Images with their respective URLs as keys.

    static private var cache: [URL: Image] = [:]
    // Subscript for getting and setting Images in the cache.

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
