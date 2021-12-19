//
//  MeditationViewController.swift
//  Calm
//
//  Created by Tim Strasser on 19/12/2021.
//

import UIKit
import CoreMotion

class MeditationViewController: UIViewController, CMHeadphoneMotionManagerDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    let motionMgr = CMHeadphoneMotionManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard motionMgr.isDeviceMotionAvailable else {
            print("Sorry", "Your device is not supported.")
            return
        }
        
        motionMgr.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion, error == nil else { return }
            self?.motionUpdated(motion)
        })
        
    }
    
    func motionUpdated(_ motion: CMDeviceMotion) {
        let data = motion.rotationRate
        
        print(data)
        
//        let pitch = String(format: "%.2f", data.pitch)
//        let roll = String(format: "%.2f", data.roll)
//        let yaw = String(format: "%.2f", data.yaw)
        let sum = data.x + data.y + data.z
        messageLabel.text = String(format: "%.2f", sum)
        
        progressBar.progress = Float(abs(sum))
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        motionMgr.stopDeviceMotionUpdates()
        self.dismiss(animated: true, completion: nil)
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
