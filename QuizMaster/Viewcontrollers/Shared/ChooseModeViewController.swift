//
//  ChooseModeViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-23.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import CoreLocation

class ChooseModeViewController: UIViewController {

    let locationManager = QuizLocationManager.shared

    @IBOutlet weak var localQuizzerButton: AddPlayerButton!
    @IBOutlet weak var onlineQuizzerButton: AddPlayerButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

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

        switch QuizLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Not determined")
            locationManager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            locationManager.startUpdatingLocation()

            if ParseDbManager.shared.currentQuizzerIsLoggedIn() {
                startOnlineTrack()
            } else {
                presentLoginViewController()
            }

        default:
            print("")
            let alertController = UIAlertController(title: "Location updates disabled",
                    message: "Please enable location updates in settings in to enjoy full functionality",
                    preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alertController, animated: true)

            if ParseDbManager.shared.currentQuizzerIsLoggedIn() {
                startOnlineTrack()
            } else {
                presentLoginViewController()
            }
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

//MARK: CLLocationManagerDelegate

extension ChooseModeViewController: CLLocationManagerDelegate {


    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {



    }

}



