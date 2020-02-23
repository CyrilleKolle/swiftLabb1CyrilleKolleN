//
//  AnimatedViewController.swift
//  swiftLabb1CyrilleKolleN
//
//  Created by Indigo´sDad on 2020-02-11.
//  Copyright © 2020 Indigo´sDad. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AnimatedViewController: UIViewController {

    @IBOutlet weak var tableView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animationSetup()
    }
    
    private func animationSetup(){
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "weather", ofType: "mov")!)
        let player = AVPlayer(url: path)
        
        let newLayer = AVPlayerLayer(player: player)
        
        newLayer.frame = self.tableView.frame
        self.tableView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
