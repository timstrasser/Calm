//
//  ViewController.swift
//  Calm
//
//  Created by Tim Strasser on 19/12/2021.
//

import UIKit

class ViewController: UIViewController {

 
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func startButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToMeditation", sender: self)
    }
    

}

