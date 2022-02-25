//
//  VideoViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 28/12/2021.
//

import UIKit

class VideoViewController: UIViewController {

    @IBAction func Back(){
        self.dismiss(animated: true)
    }
    @IBAction func _500MB(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        vc.titleName = "> 500 MB"
        vc.ID = 1
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func _100To500(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        vc.titleName = "100 - 500 MB"
        vc.ID = 2
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
     
    @IBAction func _100MB(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        vc.titleName = "< 100 MB"
        vc.ID = 3
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
     
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
