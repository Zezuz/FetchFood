//
//  ViewController.swift
//  FetchFood
//
//  Created by Michael Zanaty on 3/8/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
        
    @IBOutlet weak var tableView: UITableView!
    

    
        var desserts = [Desserts]()
    var strMeals: [String]  = []
        

        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
            fetchDessertMeals { [weak self] meals in
                        if let meals = meals {
                            self?.strMeals = meals
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                    }
            
        }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(strMeals.count)
           return strMeals.count
       }
       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
           cell.textLabel?.text = strMeals[indexPath.row]
           return cell
       }
   }
    
    struct MealsResponse: Codable {
        let meals: [Meal]
    }

    struct Meal: Codable {
        let strMeal: String
    }

    func fetchDessertMeals(completion: @escaping ([String]?) -> Void) {
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MealsResponse.self, from: data)
                let meals = response.meals.map { $0.strMeal }
                completion(meals)
                print(meals)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    
    
    
    

