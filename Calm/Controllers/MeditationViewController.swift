//
//  MeditationViewController.swift
//  Calm
//
//  Created by Tim Strasser on 19/12/2021.
//

import UIKit
import CoreMotion
import CreateML



class MeditationViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let motionMgr = CMHeadphoneMotionManager();
    var timer = Timer()
    
    var rotations: [Double] = []
    var totalTime = 30
    var secondsPassed = 0
    
    var adviceResult: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard motionMgr.isDeviceMotionAvailable else {
            print("Sorry", "Your device is not supported.")
            return
        }
        
        motionMgr.delegate = self
        
        motionMgr.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion, error == nil else { return }
            self?.motionUpdated(motion)
        })
        
        startTimer()
        
    }
    
    func startTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
        }
    }
    
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        messageLabel.text = "Stay as calm as you can."
        startTimer()
        
        progressBar.isHidden = false
        
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        if !timer.isValid {
            return
        }
        messageLabel.text = "Please connect your AirPods Pro."
        timer.invalidate()
    }
    
    func motionUpdated(_ motion: CMDeviceMotion) {
        let data = motion.rotationRate
        let sum = data.x + data.y + data.z
        rotations.append(abs(sum))
        
//        let std = rotations.std()
//
//        if let max = rotations.max() {
//            messageLabel.text = String(format: "%.2f", std) + " / " + String(format: "%.2f", max)
//        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        motionMgr.stopDeviceMotionUpdates()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            progressBar.progress = 1 - Float(secondsPassed) / Float(totalTime)
        } else {
            showResult()
        }
    }
    
    func showResult() {
        timer.invalidate()
        motionMgr.stopDeviceMotionUpdates()
        if let max = rotations.max() {
            adviceResult = getMessageFromScore(std: rotations.std(), max: max)
            progressBar.isHidden = true
            self.performSegue(withIdentifier: "goToResult", sender: self)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let desitnationVC = segue.destination as! ResultViewController
            
            desitnationVC.advice = adviceResult
        }
    }
    
    func getMessageFromScore(std: Double, max: Double) -> String{
        if max < 0.5{
            if std <= 0.02 {
                return "Congratiulations, you mastered your meditation."
            } else if std <= 0.03 {
                return "You did very well, but there is still room for improvement."
            } else {
                return "You don't seem calm just yet."
            }
            
        } else {
            if std <= 0.02 {
                return "You seem very calm, but some movements did not go unnoticed."
            } else if std <= 0.03 {
                return "You're not quite there yet. Take a deep breath and try again."
            } else {
                return "You moved a lot. Please try to focus more."
            }
        }
    }
    
}


extension Array where Element: FloatingPoint {
    
    func sum() -> Element {
        return self.reduce(0, +)
    }
    
    func avg() -> Element {
        return self.sum() / Element(self.count)
    }
    
    
    func std() -> Element {
        let mean = self.avg()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / (Element(self.count) - 1))
    }
    
}
