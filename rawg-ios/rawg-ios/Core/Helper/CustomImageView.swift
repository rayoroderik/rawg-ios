//
//  CustomImageView.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import UIKit

class CustomImageView: UIImageView {
    
    let imageCache = NSCache<NSString, UIImage>()
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                self.imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }).resume()
    }
}
