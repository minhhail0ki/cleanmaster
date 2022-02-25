//
//  HomeViewController.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 28/12/2021.
//

import UIKit
import MBCircularProgressBar
class HomeViewController: UIViewController {
    
    @IBOutlet weak var lblStorage: UILabel!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var processView: MBCircularProgressBarView!
    @IBOutlet weak var clean: UIButton!
    
    var index = 0
    var timer = Timer()
    var Calo = 0.00
    var width1 = 0.0
    let waterWaveView = WaterWaveView()
    let dr: TimeInterval = 10.0
    var timerWater: Timer?
    var timerf: Timer?
    var isActionCleaner = false
    
    @IBAction func loadSetting(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func loadPicture(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PictureViewController") as! PictureViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func loadContacts(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func loadLocation(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func loadVideo(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func btnCleaner(_ sender: Any) {
        if isActionCleaner == false{
            clean.setBackgroundImage(UIImage(named: "RESET"), for: .normal)
            self.lblStorage.text = ""
            UIView.animate(withDuration: 5.0){
                self.processView.value = 100
                self.Calo = 1 - (Double(UIDevice.current.freeDiskSpaceInBytes / (1024 * 1024 * 1024))/Double(UIDevice.current.totalDiskSpaceInBytes / (1024 * 1024 * 1024)))
                self.timerWater = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
                    let dr = CGFloat(1.0 / (self.dr/0.01))
                    self.waterWaveView.process += dr
                    self.waterWaveView.setupProcess(self.waterWaveView.process)
                    // print(self.waterWaveView.process)
                    if self.waterWaveView.process >= self.Calo {
                        self.timerWater?.invalidate()
                    }
                })
            }
        }
        else{
            self.clean.setBackgroundImage(UIImage(named: "btnCleaner"), for: .normal)
            UIView.animate(withDuration: 0.5){
                self.processView.value = 0
                self.lblStorage.text = ""
                
            }
        }
        isActionCleaner  = !isActionCleaner
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    @objc func timerAction() {
        self.lblStorage.text = "Used \(Double(UIDevice.current.freeDiskSpaceInBytes / (1024 * 1024 * 1024))) of \(Double(UIDevice.current.totalDiskSpaceInBytes / (1024 * 1024 * 1024))) GB"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.processView.value = 0
        waterWaveView.percenlbl.text = " "
        lblStorage.font = lblStorage.font.withSize(UIScreen.main.bounds.width/35.7)
        View1.addSubview(waterWaveView)
        waterWaveView.setupProcess(waterWaveView.process)
        
        NSLayoutConstraint.activate([
            
            waterWaveView.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.heightAnchor.constraint(equalToConstant: screenWidth * 0.5),
            waterWaveView.centerXAnchor.constraint(equalTo: View1.centerXAnchor),
            waterWaveView.centerYAnchor.constraint(equalTo: View1.centerYAnchor)
        ])
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.waterWaveView.process >= 0.1 {
            self.timerWater?.invalidate()
        }
        self.waterWaveView.percentAnim()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //UIView.animate(withDuration: 5.0){
        self.processView.value = 0
        //   }
    }

    

}
