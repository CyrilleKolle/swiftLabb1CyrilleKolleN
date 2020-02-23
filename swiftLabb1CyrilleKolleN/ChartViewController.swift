//
//  ChartViewController.swift
//  swiftLabb1CyrilleKolleN
//
//  Created by Indigo´sDad on 2020-02-17.
//  Copyright © 2020 Indigo´sDad. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var chartOutlet2: BarChartView!
    
    @IBOutlet weak var chartOutlet: BarChartView!
    
    var compareCity : String = ""
    
    var favoriteCity : String = ""
    
    var callback: ((String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        barChartOne()
        barChartTwo()
           }
   

    func barChartOne(){
        
                let defaults = UserDefaults.standard
               //favoriteCity = defaults.object(forKey: "fc") as? [String] ?? [String]()
        favoriteCity = defaults.object(forKey: "fc") as! String
        
//        guard let city = self.callback else {return}
//                   let y = city(self.favCity)
//                   favCL.append(y)
//
//        guard let city = self.callback else {return}
//         let y = city(self.favoriteCity)
        
        
          let wther = WeatherAPI()
               wther.getWeather(city: favoriteCity){ (result) in
                print("favorite city : \(self.favoriteCity)")
                                   switch result{
                                   case.success(let weather):
                                      
                                   DispatchQueue.main.async {
                                       
                                    let temp = BarChartDataEntry(x: 1.0, y: weather.main.temp - 273.13 )
                                       let humidity = BarChartDataEntry(x: 2.0, y: Double(weather.main.humidity))
                                       let pressure = BarChartDataEntry(x: 3.0, y: Double(weather.main.pressure))

                                       let dataSet = BarChartDataSet(entries: [temp, humidity, pressure], label: "favoriteCity")
                                       
                                       //let datat = BarChartData(dataSets: [dataSet])
                                       let data = BarChartData(dataSets: [dataSet])
                                       self.chartOutlet.data = data
                                    self.chartOutlet.chartDescription?.text = self.favoriteCity;      dataSet.colors = ChartColorTemplates.liberty()
                                    
                                       self.chartOutlet.notifyDataSetChanged()

                                                                  }
                                   case.failure(let error): print(error)
                                       }
    
                   }

    }
    
        func barChartTwo(){
            
            let wther = WeatherAPI()
                wther.getWeather(city: compareCity){ (result) in
                                    switch result{
                                    case.success(let weather):
                                       
                                    DispatchQueue.main.async {
                                        
                                        let temp = BarChartDataEntry(x: 1.0, y: weather.main.temp - 273.15)
                                        let humidity = BarChartDataEntry(x: 2.0, y: Double(weather.main.humidity))
                                        let pressure = BarChartDataEntry(x: 3.0, y: Double(weather.main.pressure))

                                        let dataSet = BarChartDataSet(entries: [temp, humidity, pressure], label: "compareCity")
                                        
                                        //let datat = BarChartData(dataSets: [dataSet])
                                        let data = BarChartData(dataSets: [dataSet])
                                        self.chartOutlet2.data = data
                                        self.chartOutlet2.chartDescription?.text = self.compareCity;      dataSet.colors = ChartColorTemplates.joyful()
                                        self.chartOutlet2.notifyDataSetChanged()

                                                                   }
                                    case.failure(let error): print(error)
                                        }
     
                    }
    

        }

}
