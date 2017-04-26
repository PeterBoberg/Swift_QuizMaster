//
//  MultiplayerStartViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-25.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.navigationController)

    }


    @IBAction func searchFriends(_ sender: CircularButton) {
        print("Searching friends")
        let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "MulitplayerSerachFriendsController") as! MulitplayerSerachFriendsController
        searchVc.modalPresentationStyle = .overCurrentContext
        searchVc.modalTransitionStyle = .crossDissolve
        self.present(searchVc, animated: true)
    }

    @IBAction func logOut(_ sender: CircularButton) {
        ParseDbManager.shared.logOutCurrentUser()
        self.navigationController?.popToRootViewController(animated: true)
    }

    deinit {
        print("MultiplayerStartViewController destroyed")
    }
}


