//
//  File.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/15/22.
//

import UIKit

class LoadingScreenVC: UIViewController {

    @IBOutlet weak var propellorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
        // Do any additional setup after loading the view.
    }
    private func animate(){
        UIView.animate(withDuration: 2, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = Double.pi * 5.5
            rotation.duration = 2 // or however long you want ...
                rotation.isCumulative = true
                rotation.repeatCount = Float.greatestFiniteMagnitude
            self.propellorImage.layer.add(rotation, forKey: "rotationAnimation")
            self.propellorImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.propellorImage.alpha = 0
        })
    }
}
