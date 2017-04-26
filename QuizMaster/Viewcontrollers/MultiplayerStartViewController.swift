//
//  MultiplayerStartViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-25.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerStartViewController: UIViewController {

    @IBOutlet weak var friendsCollectionView: UICollectionView!

    let friendsCollectionViewDatasource = OnlineFriendsCollectionViewDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsCollectionView.dataSource = friendsCollectionViewDatasource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
        downloadFriends()
    }


    @IBAction func searchFriends(_ sender: CircularButton) {
        print("Searching friends")
        let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "MulitplayerSerachFriendsController") as! MulitplayerSerachFriendsController
        searchVc.modalPresentationStyle = .overCurrentContext
        searchVc.modalTransitionStyle = .crossDissolve
        self.present(searchVc, animated: true)
    }

    private func downloadFriends() {
        if ParseDbManager.shared.currentUserIsLoggedIn() {
            let currentUser = ParseDbManager.shared.currentUser()!
            ParseDbManager.shared.findFriendsOf(quizzer: currentUser, completion: {

                [weak self](friends, error) in
                guard error == nil else {
                    //TODO implement better errorhandling here
                    print(error)
                    return
                }
                if let friends = friends {
                    self?.friendsCollectionViewDatasource.friends = friends
                    self?.friendsCollectionView.reloadData()
                }
            })
        }
    }

    @IBAction func logOut(_ sender: CircularButton) {
        ParseDbManager.shared.logOutCurrentUser()
        self.navigationController?.popToRootViewController(animated: true)
    }

    deinit {
        print("MultiplayerStartViewController destroyed")
    }
}


