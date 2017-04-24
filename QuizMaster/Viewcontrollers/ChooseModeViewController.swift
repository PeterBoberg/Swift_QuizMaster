//
//  ChooseModeViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-23.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class ChooseModeViewController: UIViewController {

    @IBOutlet weak var localQuizzerButton: AddPlayerButton!
    @IBOutlet weak var onlineQuizzerButton: AddPlayerButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func startLocalQuizMode(_ sender: UIButton) {
        let localTrackVc = self.storyboard?.instantiateViewController(withIdentifier: "LocalTrackNavController") as! UINavigationController
        self.present(localTrackVc, animated: true)
    }

    @IBAction func onlineQuizMode(_ sender: UIButton) {

        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVc.modalTransitionStyle = .crossDissolve
        loginVc.modalPresentationStyle = .overCurrentContext
        self.present(loginVc, animated: true)
    }

    deinit {
        print("ChooseModeViewController destroyed")
    }
}


