//
//  water.swift
//  Clean Master 3
//
//  Created by Le Minh Hai on 15/01/2022.
//

import UIKit
let screenWidth = UIScreen.main.bounds.size.width


class WaterWaveView: UIView{
    //Mark -property
    private let firstLayer = CAShapeLayer()
    private let secondLayer = CAShapeLayer()
    
    private var firstColor:UIColor = .clear
    private var secondColor: UIColor = .clear
    
    public let percenlbl = UILabel()
    
    private let twoPi: CGFloat = .pi*2
    private var offset : CGFloat = 0.0
    
    private let width = screenWidth*0.5
    
    var showSingleWave = false
    private var start = false
    
    var process: CGFloat = 0.0
    var processMax: CGFloat = 0.0
    var waveheight:CGFloat = 0.0
    
    // mark init
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
}

//mark = setups
extension WaterWaveView{
    private func setupView(){
        bounds = CGRect(x: 0.0, y: 0.0, width: min(width, width), height: min(width, width))
        clipsToBounds = true
        backgroundColor = .clear
        layer.cornerRadius = (width/2)
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
     //   layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
        waveheight = 20
        
        firstColor = .white.withAlphaComponent(0.4)
        secondColor = .white.withAlphaComponent(0.1)
        
        createFirstlayer()
        
        if !showSingleWave{
            createSecondlayer()
        }
        createPercentLbl()
    }
    private func createFirstlayer(){
        firstLayer.frame = bounds
        firstLayer.anchorPoint = .zero
        firstLayer.fillColor = firstColor.cgColor
        layer.addSublayer(firstLayer)
    }
    private func createSecondlayer(){
        secondLayer.frame = bounds
        secondLayer.anchorPoint = .zero
        secondLayer.fillColor = secondColor.cgColor
        layer.addSublayer(secondLayer)
    }
    private func createPercentLbl(){
        percenlbl.font = UIFont.boldSystemFont(ofSize: 32.0)
        percenlbl.textAlignment = .center
        percenlbl.text = " "
        percenlbl.textColor = .white
        addSubview(percenlbl)
        percenlbl.translatesAutoresizingMaskIntoConstraints = false
        percenlbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        percenlbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    func percentAnim(){
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.duration = 1.0
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        percenlbl.layer.add(anim, forKey: nil)
    }
     func setupProcess(_ pr: CGFloat){
        process = pr
        
         percenlbl.text = String(format: "%ld%%", NSNumber(value: Float(pr*100)).intValue)
//         if pr == 0.95 {
//             percenlbl.text = String(format: "%ld%%", NSNumber(value: Float(pr*100) + 5).intValue)
//         }
        let top: CGFloat = pr * bounds.size.height
        firstLayer.setValue(width-top, forKeyPath: "position.y")
        secondLayer.setValue(width-top, forKeyPath: "position.y")
        
        if !start{
            DispatchQueue.main.async {
                self.startAnim()
            }
        }
    }
    private func startAnim(){
        start = true
        waterWaveAnim()
    }
    private func waterWaveAnim()  {
        let w = bounds.size.width
        let h = bounds.size.height
        
        let bezier = UIBezierPath()
        let path = CGMutablePath()
        
        let startOffsetY = waveheight * CGFloat(sinf(Float(offset * twoPi / w)))
        var originOffsetY : CGFloat = 0.0
        
        path.move(to: CGPoint(x: 0.0, y: startOffsetY), transform: .identity)
        bezier.move(to: CGPoint(x: 0.0, y: startOffsetY))
        
        for i in stride(from: 0.0, to: w*1000, by: 1 ) {
            originOffsetY = waveheight * CGFloat(sinf(Float(twoPi / w * i + offset * twoPi / w)))
            bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
            
        }
            bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
            bezier.addLine(to: CGPoint(x: w*1000, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: h))
            bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
            bezier.close()
            
        let anim = CABasicAnimation(keyPath: "transform.translation.x")
        anim.duration = 15.0
        anim.fromValue = -w*0.5
        anim.toValue = -w - w*05
        anim.repeatCount = .infinity
        anim.isRemovedOnCompletion = false
        
            firstLayer.fillColor = firstColor.cgColor
            firstLayer.path = bezier.cgPath
        firstLayer.add(anim, forKey: nil)
            
        if !showSingleWave{
            let bezier = UIBezierPath()
     
            
            let startOffsetY = waveheight * CGFloat(sinf(Float(offset * twoPi / w)))
            var originOffsetY : CGFloat = 0.0
            
            path.move(to: CGPoint(x: 0.0, y: startOffsetY), transform: .identity)
            bezier.move(to: CGPoint(x: 0.0, y: startOffsetY))
            
            for i in stride(from: 0.0, to: w*1000, by: 1 ) {
                originOffsetY = waveheight * CGFloat(cosf(Float(twoPi / w * i + offset * twoPi / w)))
                bezier.addLine(to: CGPoint(x: i, y: originOffsetY))
                
            }
                bezier.addLine(to: CGPoint(x: w*1000, y: originOffsetY))
                bezier.addLine(to: CGPoint(x: w*1000, y: h))
                bezier.addLine(to: CGPoint(x: 0.0, y: h))
                bezier.addLine(to: CGPoint(x: 0.0, y: startOffsetY))
                bezier.close()
                
            let anim = CABasicAnimation(keyPath: "transform.translation.x")
            anim.duration = 15.0
            anim.fromValue = -w*0.5
            anim.toValue = -w - w*05
            anim.repeatCount = .infinity
            anim.isRemovedOnCompletion = false
            
            secondLayer.fillColor = secondColor.cgColor
            secondLayer.path = bezier.cgPath
            secondLayer.add(anim, forKey: nil)

        }
        

    }
}

