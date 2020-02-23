//
//  DetailViewController.swift
//  swiftLabb1CyrilleKolleN
//
//  Created by Indigo´sDad on 2020-02-11.
//  Copyright © 2020 Indigo´sDad. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var DayOrNightOutlet: UITextField!
    
    @IBOutlet weak var outfitDisplay: UITextField!
    
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var precipitationDisplay: UILabel!
    @IBOutlet weak var snowDisplay: UILabel!
    
    @IBOutlet weak var rainDisplay: UILabel!
    @IBOutlet weak var windDisplay: UILabel!
    
    @IBOutlet weak var tempDisplay: UILabel!
    
    @IBOutlet weak var iconViewOutlet: UIImageView!
    @IBOutlet weak var humidityDisplay: UILabel!
    
    @IBOutlet weak var smallTempOutlet: UILabel!
    var searchCity: String = ""
    
    let baseURL: String = "https://openweathermap.org/img/wn/"
    var iconText: String = ""
    var iconURL: String = ""
    
    var historySearch: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
  
                       let wtherAPI = WeatherAPI()
        wtherAPI.getWeather(city: searchCity){ (result) in
                            switch result{
                            case.success(let weather):
                               
                            DispatchQueue.main.async {
                                
                                self.tempDisplay.text = String(format: "%.1f", weather.main.temp - 273 ) + " °C"
                               self.smallTempOutlet.text = String(format: "%.1f", weather.main.temp - 273 ) + " °C"
                               self.humidityDisplay.text = String(weather.main.humidity) + "%"
                             
                                self.precipitationDisplay.text = String(format: "%.1f", weather.main.pressure * 100 ) + "m"
                                self.rainDisplay.text = String(weather.clouds.all) + " %"
                                self.windDisplay.text = String(weather.wind.speed) + " KmH"
                                self.snowDisplay.text = String(weather.main.pressure / 1000) + " kPa"
                                
                                self.iconText = "\(weather.weather[0].icon)@2x.png"
                                self.iconURL = self.baseURL + self.iconText
                                self.setImage(url: self.iconURL)
                                
                                
                                switch (weather.main.temp - 273.15) {
                                case -50...0:
                                    self.outfitDisplay.text = "Thick Jackets are fabulous"
                                case 1...7:
                                    self.outfitDisplay.text = "Waterproof Shoes for slush"
                                case 8...12:
                                     self.outfitDisplay.text = "Umbrellas are a compliment"
                                case 13...20:
                                     self.outfitDisplay.text = "Show some skin with tshirts"
                                case 21...100:
                                     self.outfitDisplay.text = "You need alot of sunscreen"
                                default:  print("no data available")
                                   
                                }
                        
                                   
                               
                                if weather.weather[0].icon.contains("d"){
                                    self.backgroundColor(timeOfDay: false)
                                    
                                    Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.alarmActivate), userInfo: nil, repeats: true)
                                     
                                }else{
                                    self.backgroundColor(timeOfDay: true)
                                    
                                    
                                    Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.alarmAlertActivate), userInfo: nil, repeats: true)
                                }

                               }
                            case.failure(let error): print(error)
                                }
          
    }
        
        let defaults = UserDefaults.standard
       historySearch = defaults.object(forKey: "history") as? [String] ?? [String]()
         print("searched cities saved: \(historySearch)")
    


}
    override func viewDidAppear(_ animated: Bool) {
        saveCity()
    }
    override func viewWillAppear(_ animated: Bool) {
        saveCity()
    }

   func setImage(url: String) {
       guard let imageURL = URL(string: url) else { return }

       DispatchQueue.global().async {
           guard let imageData = try? Data(contentsOf: imageURL) else { return }

           let image = UIImage(data: imageData)
           DispatchQueue.main.async {
               self.iconViewOutlet.image = image
           }
       }
   }
    func backgroundColor(timeOfDay: Bool){
        if timeOfDay == true{
           tableView.backgroundColor = UIColor(red: 142 / 255.0, green: 142 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        }
        else {
            tableView.backgroundColor = UIColor(red: 0.0, green:1.0, blue: 1.0, alpha: 1.0)
          
            
        }
    }

    @objc func alarmAlertActivate(){
        UIView.animate(withDuration: 0.7) {
            self.DayOrNightOutlet.text = "Night"
            self.DayOrNightOutlet.alpha = self.DayOrNightOutlet.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    @objc func alarmActivate(){
        UIView.animate(withDuration: 0.7) {
            self.DayOrNightOutlet.text = "Day"
            self.DayOrNightOutlet.alpha = self.DayOrNightOutlet.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    func saveCity(){
        let defaults = UserDefaults.standard
        defaults.set(self.historySearch, forKey: "history")
        historySearch.append(searchCity)
        print(historySearch)
    }
}

