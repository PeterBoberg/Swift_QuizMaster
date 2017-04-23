//
//  LocalUsersViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-20.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class LocalUsersViewController: UIViewController {

    let userCollectionViewDataSource: UserCollectionViewDatasource = UserCollectionViewDatasource()
    let dbManager = LocalDbManager.shared


    @IBOutlet weak var usersCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = userCollectionViewDataSource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadQuizPlayers()
    }


    @IBAction func addNewPlayer(_ sender: UIButton) {
        let addUserVc = self.storyboard!.instantiateViewController(withIdentifier: "AddLocalUserViewController") as! AddLocalUserViewController
        addUserVc.modalPresentationStyle = .overCurrentContext
        addUserVc.modalTransitionStyle = .crossDissolve
        addUserVc.delegate = self
        self.present(addUserVc, animated: true)

    }

    deinit {
        print("UsersViewController destroyed")
    }
}

// MARK: Private methods

extension LocalUsersViewController {

    fileprivate func loadQuizPlayers() {

        dbManager.getAllQuizPlayers(completion: {
            [unowned self] (quizPlayers, error) in
            guard error == nil else {
                print(error)
                return
            }

            self.userCollectionViewDataSource.quizPlayers = quizPlayers!
            self.usersCollectionView.reloadData()
        })
    }

}

// MARK: UICollectionViewDelegate

extension LocalUsersViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryVC = self.storyboard!.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        categoryVC.currentPlayer = userCollectionViewDataSource.quizPlayers[indexPath.row]
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }

}

// MARK: AddUserViewControllerDelegate

extension LocalUsersViewController: AddLocalUserViewControllerDelegate {

    func addUserViewController(didFinishEnterUserInfoWithName name: String, image: UIImage?) {
        dbManager.saveNewQuizPlayer(name: name, avatar: image, completion: {
            [unowned self] (error) in
            guard error == nil else {
                print(error)
                return
            }
            self.loadQuizPlayers()
        })
    }

    func addUserViewControllerCancelled() {
        print("User cancelled")
    }

}

