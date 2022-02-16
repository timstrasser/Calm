//
//  ResultViewController.swift
//  Calm
//
//  Created by Tim Strasser on 09/01/2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    var advice: String?
    @IBOutlet weak var adviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adviceLabel.text = advice
    }
    
    @IBAction func returnHomeClicked(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
