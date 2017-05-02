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

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }


    @IBAction func startLocalQuizMode(_ sender: UIButton) {
        let localUsersVc = self.storyboard?.instantiateViewController(withIdentifier: "LocalUsersViewController") as! LocalUsersViewController
        self.navigationController?.pushViewController(localUsersVc, animated: true)

    }

    @IBAction func onlineQuizMode(_ sender: UIButton) {

        print(ParseDbManager.shared.currentQuizzerIsLoggedIn())
        if ParseDbManager.shared.currentQuizzerIsLoggedIn() {
            startOnlineTrack()
        } else {
            presentLoginViewController()
        }
    }

    deinit {
        print("ChooseModeViewController destroyed")
    }
}


// MARK: Private methods

extension ChooseModeViewController {

    fileprivate func presentLoginViewController() {
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVc.delegate = self
        loginVc.modalTransitionStyle = .crossDissolve
        loginVc.modalPresentationStyle = .overCurrentContext
        self.present(loginVc, animated: true)
    }

    fileprivate func startOnlineTrack() {
        let onlineTrackTabBarVc = self.storyboard?.instantiateViewController(withIdentifier: "OnlineTrackTabBarController") as! UITabBarController
        self.navigationController?.pushViewController(onlineTrackTabBarVc, animated: true)
    }
}


// MARK: LoginViewControllerDelegate

extension ChooseModeViewController: LoginViewControllerDelegate {

    func didFinishAuthenticating() {
        startOnlineTrack()
    }
}


