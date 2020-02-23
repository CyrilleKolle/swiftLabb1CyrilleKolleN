//
//  MyTableViewCell.swift
//  swiftLabb1CyrilleKolleN
//
//  Created by Indigo´sDad on 2020-02-11.
//  Copyright © 2020 Indigo´sDad. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    
    var sc = searchViewController()
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!

    let baseURLicon: String = "https://openweathermap.org/img/wn/"
          var iconText: String = ""
          var iconURL: String = ""
    
    @IBOutlet weak var tempOutlet: UITextField!
    @IBOutlet weak var compareOutlet: UIButton!
    
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    var animate:Bool = false
    var callback: ((String) -> (String))?
    var favCity: String = ""
    var favCL: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        animator = UIDynamicAnimator(referenceView: self.contentView)
        gravity = UIGravityBehavior(items: [favoriteButtonOutlet])
        collision = UICollisionBehavior(items: [favoriteButtonOutlet])
        collision.translatesReferenceBoundsIntoBoundary = true
        
    }
    
    @IBAction func compareButton(_ sender: Any) {
        // UIView.setAnimationsEnabled(false)
       // favoriteButtonOutlet.layer.removeAllAnimations()
    }
    
    @IBOutlet weak var CompareButton: UIView!
    
    @IBAction func trashButton(_ sender: Any) {
        
    }
    
    @IBAction func favoriteButton(_ sender: Any) {

        if favCL.count == 0{
            
     
            guard let city = self.callback else {return}
            let newCity = city(self.favCity)
            favCL.append(newCity)
            let defaults = UserDefaults.standard
            defaults.set(newCity, forKey: "fc")
            

            print("favcl: \(favCL)")
    
            
        } else if(favCL.count > 1){
            favCL.removeAll()
            guard let city = self.callback else {return}
            let newCity = city(self.favCity)
            favCL.append(newCity)
            print("favcl: \(favCL)")
            
        }
    }

 

}
