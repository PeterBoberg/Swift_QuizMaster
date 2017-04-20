//
//  UsersViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-20.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    let userCollectionViewDataSource: UserCollectionViewDatasource = UserCollectionViewDatasource()
    let dbManager = DBManager.shared


    @IBOutlet weak var usersCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = userCollectionViewDataSource
        loadQuizPlayers()
    }


    @IBAction func addNewPlayer(_ sender: UIButton) {
        let addUserVc = self.storyboard!.instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
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

extension UsersViewController {

    fileprivate func loadQuizPlayers() {

        dbManager.getAllQuizPlayers(completion: {
            [unowned self] (quizPlayers, error) in
            guard error == nil else {
                print(error)
                return
            }
            guard let quizPlayers = quizPlayers else {
                print("Quizplayers is nil")
                return
            }

            self.userCollectionViewDataSource.quizPlayers = quizPlayers
            self.usersCollectionView.reloadData()
        })
    }

}

// MARK: UICollectionViewDelegate

extension UsersViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        print(indexPath.section)
        let categoryVC = self.storyboard!.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }

}

// MARK: AddUserViewControllerDelegate

extension UsersViewController: AddUserViewControllerDelegate {

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

