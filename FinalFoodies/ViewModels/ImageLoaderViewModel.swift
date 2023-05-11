//
//  ImageLoaderViewModel.swift
//  FinalFoodies
//
//  Created by Chika Ohaya on 3/16/22.
//
import SwiftUI
import Foundation

class ImageLoaderViewModel: ObservableObject {
    
    let url: String?
    @Published var image: UIImage? = nil
    @Published var errorMessage: Error? = nil
    var cache: NSCache<NSString, UIImage> = NSCache()
    
    init(url: String?) {
        self.url = url
    }
    
    func fetchImageData() {
        guard let url = url, let fetchURL = URL(string: url) else {
            errorMessage = StatusCodes.networkError
            return
        }
        
        if let image = cache.object(forKey: url as NSString) {
            self.image = image
            return
        }
        
        let task = URLSession.shared.dataTask(with: fetchURL) {[weak self] (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self?.errorMessage = StatusCodes.networkError
                    return
                }else if let data = data, let image = UIImage(data: data){
                    self?.image = image
                    self?.cache.setObject(image, forKey: url as NSString)
                }
            }
        }
        task.resume()
    }
}
