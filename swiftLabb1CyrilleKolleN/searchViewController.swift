//
//  searchViewController.swift
//  searchLesson
//
//  Created by Indigo´sDad on 2020-02-10.
//  Copyright © 2020 Indigo´sDad. All rights reserved.
//

import UIKit


class searchViewController: UIViewController {
    @IBOutlet weak var feelsLikeOutlet: UILabel!
    
    
    @IBOutlet weak var globeOutlet: UIButton!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet var searchView: UIView!
    
    @IBOutlet weak var humidityOutlet: UILabel!
    @IBOutlet weak var tempOutlet: UILabel!
    @IBOutlet weak var cityOutlet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let baseURLicon: String = "https://openweathermap.org/img/wn/"
       var iconText: String = ""
       var iconURL: String = ""
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!

    
  let searchController: UISearchController = UISearchController(searchResultsController: nil)

    var citi = MajorCity()
      
    var favoriteCity : String = ""
    var citiesList: [String] = []
    var searchText: String = ""
    
    
    var filteredCitiesList:[String] = []
    var favCities: [String] = []
    
    var searched : [String] = []
    var historyCities : [String] = []
    
    var isSearching: Bool{
        if filteredCitiesList.count > 0{
        return true
    }
    return false
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [globeOutlet])
        collision = UICollisionBehavior(items: [globeOutlet])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        roundedButton(globeOutlet)
        startAnime(globeOutlet)
        
        navigationItem.searchController = searchController
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        let defaults = UserDefaults.standard
       historyCities = defaults.object(forKey: "history") as? [String] ?? [String]()
        print("searched cities saved: \(historyCities)")
        
//        if favoriteCity == ""{
//            favoriteCity = "Welcome"
//        }else{
//
        if let loadedCity = defaults.object(forKey: "fc") as? String {
            favoriteCity = loadedCity

        } else {
            favoriteCity = "Welcome"
        }
     //   }
        
        
        loadFavoriteCity()
        favoriteView()
        
    }
    func setImage(url: String) {
         guard let imageURL = URL(string: url) else { return }

             
         DispatchQueue.global().async {
             guard let imageData = try? Data(contentsOf: imageURL) else { return }

             let image = UIImage(data: imageData)
             DispatchQueue.main.async {
                 self.weatherImage.image = image
             }
         }
     }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
         let defaults = UserDefaults.standard
              historyCities = defaults.object(forKey: "history") as? [String] ?? [String]()
               print("searched cities saved: \(historyCities)")
        favoriteCity = defaults.object(forKey: "fc") as! String
        
        favoriteView()
        loadFavoriteCity()
        
      
        startAnime(globeOutlet)
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
      
        
        let defaults = UserDefaults.standard
        historyCities = defaults.object(forKey: "history") as? [String] ?? [String]()
        favoriteCity = defaults.object(forKey: "fc") as! String
        
        favoriteView()
        loadFavoriteCity()
        
        roundedButton(globeOutlet)
        startAnime(globeOutlet)
        
    
    }
    
    func startAnime(_ object: AnyObject){
        
        object.layer?.cornerRadius = object.frame.size.width/2
              object.layer?.masksToBounds = true
        
               UIView.animate(withDuration: 1.0, delay: 1.0, options: .repeat  , animations: {
        
                   self.globeOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        
                
        
                 })
    }
    func roundedButton(_ object: AnyObject){
        
        object.layer?.cornerRadius = object.frame.size.width/2
        object.layer?.masksToBounds = true

             UIView.animate(withDuration: 1.0, delay: 1.0, options: .repeat  , animations: {

                self.globeOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
                

                self.animator.addBehavior(self.gravity)
                self.animator.addBehavior(self.collision)
        }, completion: { _ in
            
                self.globeOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))

                          self.globeOutlet.transform = CGAffineTransform(translationX: 1.0, y: 1.0)
                            
                            self.animator.removeBehavior(self.gravity)
                          
            
        })
    }
    
}

extension searchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if isSearching{
           
            return filteredCitiesList.count
                   }
        return historyCities.count
   
      }

      
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            historyCities.remove(at: indexPath.row)
    
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    
    

    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        if isSearching{
            
            cell.textLabel?.text = filteredCitiesList[indexPath.row]
            
                           let wtherAPI = WeatherAPI()
            wtherAPI.getWeather(city: filteredCitiesList[indexPath.row]){ (result) in
                                switch result{
                                case.success(let weather):
                                   
                                DispatchQueue.main.async {
                                    cell.tempOutlet.text = String(format: "%.1f", weather.main.temp - 273.15 ) + " °C"
                                
                                    cell.callback = { city in
                                        self.cityOutlet.text = city
                                        self.favoriteCity = cell.favCity
                                        
                                        return cell.favCity
                                    }
                                    
                                    cell.favCity = self.filteredCitiesList[indexPath.row]
                                    self.favoriteCity = cell.favCity
      
                                   }
                                case.failure(let error): print(error)
                                    }
            
            }
            
        }else{
            
            cell.textLabel?.text = historyCities[indexPath.row]
            
            
      }
        return cell

    }
}
extension searchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let citiesList = citi.cities

      
        print("SearchText: \(searchController.searchBar.text ?? "")")
        
        if let searchText = searchController.searchBar.text?.lowercased(){
            
            filteredCitiesList = citiesList.filter({$0.lowercased().contains(searchText.lowercased())})
            
               
        }
        else{
            filteredCitiesList = []
        }
        // self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        tableView.reloadData()
    }
    func favoriteView(){
        
        let defaults = UserDefaults.standard
        defaults.set(favoriteCity, forKey: "fc")
        
        let wtherAPI = WeatherAPI()
         wtherAPI.getWeather(city: favoriteCity){ (result) in
                         switch result{
                         case.success(let weather):

                         DispatchQueue.main.async {
                            
                            self.cityOutlet.text = self.favoriteCity

                             self.iconText = "\(weather.weather[0].icon)@2x.png"
                                                          self.iconURL = self.baseURLicon + self.iconText
                                                          self.setImage(url: self.iconURL)

                             self.tempOutlet.text = String(format: "%.1f", weather.main.temp - 273 ) + " °C"
                            self.humidityOutlet.text =   String(weather.main.feelsLike)

                            }
                         case.failure(let error): print(error)
                             }

                         }
        
    }
    func loadFavoriteCity(){
        let defaults = UserDefaults.standard
        defaults.set(favoriteCity, forKey: "fc")
        
        let wtherAPI = WeatherAPI()
         wtherAPI.getWeather(city: favoriteCity){ (result) in
                         switch result{
                         case.success(let weather):

                         DispatchQueue.main.async {
                                self.cityOutlet.text = self.favoriteCity
                             self.iconText = "\(weather.weather[0].icon)@2x.png"
                                                          self.iconURL = self.baseURLicon + self.iconText
                                                          self.setImage(url: self.iconURL)

                            self.tempOutlet.text = String(format: "%.1f", weather.main.temp - 273.15 ) + " °C"
                            self.humidityOutlet.text = String(format: "%.1f", weather.main.feelsLike - 273.15 ) + " °C"

                            }
                         case.failure(let error): print(error)
                             }

                         }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailController = segue.destination as! DetailViewController
            
             let citiesList = citi.cities
            if let cell = sender as? MyTableViewCell{
                let indexOfCell : Int = tableView.indexPath(for: cell)!.row
               let  searchCity = citiesList[indexOfCell]
                detailController.searchCity = searchCity
                
               
             
            }
            
        
        }
        if segue.identifier == "compareSegue" {
            let compareController = segue.destination as! ChartViewController
            let indexPath : NSIndexPath
            if let button = sender as? UIButton{
                let cell = button.superview?.superview as! MyTableViewCell
                indexPath = self.tableView.indexPath(for: cell)! as NSIndexPath
               // let indexOfCell : Int = tableView.indexPath(for: cell)!.row
                
                let compareCity = citi.cities[indexPath.row]
                print("nme of compare city \(compareCity)")
                compareController.compareCity = compareCity
                
            }
        }
        
    }

}

