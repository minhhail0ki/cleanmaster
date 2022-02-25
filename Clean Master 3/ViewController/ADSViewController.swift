//
//  ADSViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 28/12/2021.
//

import UIKit
import SwiftGifOrigin

class ADSViewController: UIViewController {
    var counter = 5
    
    @IBOutlet weak var ImageGIF: UIImageView!
    
    @IBAction func btnStart(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .crossDissolve
        self.present(vc!, animated: true)
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageGIF.image = UIImage.gif(name: "535109a26888e9a50571792c19bcf3eb")

        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc func updateCounter() {
        if counter > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            counter -= 2
        }
    }
}

