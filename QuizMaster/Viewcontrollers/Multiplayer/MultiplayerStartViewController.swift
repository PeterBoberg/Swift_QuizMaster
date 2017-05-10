//
//  MultiplayerStartViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-25.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import Alamofire

class MultiplayerStartViewController: UIViewController {

    @IBOutlet weak var currentUserImageView: AvatarImageView!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var friendsCollectionView: UICollectionView!

    let dispatchGroup = DispatchGroup()
    var progressViewController: ProgressIndicatorViewController!
    let friendsCollectionViewDatasource = OnlineFriendsCollectionViewDatasource()
    let currentQuizzer = ParseDbManager.shared.currentQuizzer()!

    //MARK: Lifecyclemethods
    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProgressIndicatorViewController") as! ProgressIndicatorViewController
        progressViewController.modalTransitionStyle = .crossDissolve
        progressViewController.modalPresentationStyle = .overCurrentContext
        friendsCollectionView.dataSource = friendsCollectionViewDatasource
        friendsCollectionView.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteFriend(longPressRecognizer:)))
        longPress.minimumPressDuration = 1.0
        longPress.delaysTouchesBegan = true
        friendsCollectionView.addGestureRecognizer(longPress)
        currentUserLabel.text = currentQuizzer.username
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(progressViewController, animated: true)
        downloadAvatarImage()
        downloadFriends()
        dispatchGroup.notify(queue: .main, execute: {
            [unowned self] in
            self.progressViewController.dismiss(animated: true)
        })
    }


    //MARK: UI input methods
    @IBAction func searchFriends(_ sender: CircularButton) {
        print("Searching friends")
        let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "MulitplayerSerachFriendsController") as! MultiplayerSearchFriendsController
        searchVc.modalPresentationStyle = .overCurrentContext
        searchVc.modalTransitionStyle = .crossDissolve
        searchVc.delegate = self
        self.present(searchVc, animated: true)
    }

    @IBAction func logOut(_ sender: CircularButton) {
        ParseDbManager.shared.logOutCurrentQuizzer()
        self.navigationController?.popToRootViewController(animated: true)
    }


    deinit {
        print("MultiplayerStartViewController destroyed")
    }
}


//MARK: Private methods

extension MultiplayerStartViewController {

    fileprivate func downloadAvatarImage() {

        dispatchGroup.enter()
        ParseDbManager.shared.bgDownloadAvatarPictureFor(quizzer: currentQuizzer, completion: {
            [unowned self] (image, error) in
            self.dispatchGroup.leave()

            guard error == nil else {
                //TODO better error handing
                print(error)
                return
            }

            self.currentUserImageView.image = image
        })

    }

    fileprivate func downloadFriends() {

        dispatchGroup.enter()
        ParseDbManager.shared.bgFindFriendsOf(quizzer: currentQuizzer, completion: {
            [unowned self] (friends, error) in
            self.dispatchGroup.leave()

            guard error == nil else {
                //TODO implement better errorhandling here
                print(error)
                return
            }
            if let friends = friends {
                self.friendsCollectionViewDatasource.friends = friends
                self.friendsCollectionView.reloadData()
            }
        })
    }

    @objc fileprivate func deleteFriend(longPressRecognizer: UILongPressGestureRecognizer) {
        if longPressRecognizer.state != .ended {
            print("Deleting friend")
            let pressedPosition = longPressRecognizer.location(in: self.friendsCollectionView)
            let indexPath = self.friendsCollectionView.indexPathForItem(at: pressedPosition)
            if let indexPath = indexPath {
                let chosenFriend = self.friendsCollectionViewDatasource.friends[indexPath.row]
                let title = "Message"
                let message = "Are you shure you want to delete \(chosenFriend.username!) from your list?"

                let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

                alertController.addAction(UIAlertAction(title: "Yes, off you go!", style: .destructive, handler: {
                    [unowned self] (alertAction) in
                    ParseDbManager.shared.bgDeleteFriendOfQuizzer(quizzer: self.currentQuizzer, friend: chosenFriend, completion: {
                        [unowned self] (success, error) in

                        guard error == nil else {
                            print(error)
                            return
                        }

                        self.downloadFriends()
                    })

                }))

                alertController.addAction(UIAlertAction(title: "Heck no!", style: .cancel))
                self.present(alertController, animated: true)
            }
        }
    }
}


//MARK: CollectionViewDelegate

extension MultiplayerStartViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let chosenFriend = friendsCollectionViewDatasource.friends[indexPath.row]
        let currentQuizzer = ParseDbManager.shared.currentQuizzer()!

        // Check if already involved in game
        self.present(progressViewController, animated: true)
        ParseDbManager.shared.bgCheckPendingMatches(firstQuizzer: currentQuizzer, secondQuizzer: chosenFriend, completion: {
            [unowned self] (pendingMatches: Bool, error: Error?) in

            self.progressViewController.dismiss(animated: true, completion: {
                [unowned self] in
                guard  error == nil else {
                    print(error)
                    return
                }
                if !pendingMatches {
                    print("OK, proceeding")
                    let newMatchRequestVc = self.storyboard?.instantiateViewController(withIdentifier: "MultiplayerNewMatchViewController") as! MultiplayerNewMatchViewController
                    newMatchRequestVc.challengedQuizzer = chosenFriend
                    self.navigationController?.pushViewController(newMatchRequestVc, animated: true)

                } else {
                    let alertController = UIAlertController(title: "OOps!", message: "You already have a game with \(chosenFriend.username!)", preferredStyle: .actionSheet)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(alertController, animated: true)
                }
            })
        })
    }
}

//MARK: MultiplayerSearchFriendsControllerDelegate

extension MultiplayerStartViewController: MultiplayerSearchFriendsControllerDelegate {

    func didFinishSelectingNewFriend(quizzer: Quizzer) {
        self.downloadFriends()
    }

}


