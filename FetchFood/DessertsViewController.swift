//
//  DessertsViewController.swift
//  FetchFood
//
//  Created by Michael Zanaty on 3/8/23.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class DessertsViewController: UIViewController {

    @IBOutlet weak var dessertName: UILabel!
    @IBOutlet weak var dessertIngredients: UILabel!
    @IBOutlet weak var dessertInstructions: UILabel!
    
    var dessert: Desserts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dessertName.text = dessert?.strMeal
        dessertIngredients.text = dessert?.strIngredient1
        dessertInstructions.text = dessert?.strInstructions
        
    }
}


