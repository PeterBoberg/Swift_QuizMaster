//
//  MulitplayerSerachFriendsController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-26.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MulitplayerSerachFriendsController: UIViewController {

    @IBOutlet weak var modalSubView: UIView!
    @IBOutlet weak var searchFriendsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let searchFriendsTableViewDatasource = SearchFriendsTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.modalSubView.layer.borderWidth = 2
        self.modalSubView.layer.borderColor = UIColor.yellow.cgColor
        self.modalSubView.layer.cornerRadius = 10
        self.modalSubView.layer.masksToBounds = true

        self.searchFriendsTableView.dataSource = searchFriendsTableViewDatasource
        self.searchFriendsTableView.backgroundColor = UIColor(red: 22 / 255, green: 58 / 255, blue: 110 / 255, alpha: 1.0)

        self.searchBar.delegate = self
        self.searchFriendsTableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    deinit {
        print("MulitplayerSerachFriendsController destroyed")
    }

}

//Mark: TableViewDelegate

extension MulitplayerSerachFriendsController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Adding friend")
        let chosenFiend = searchFriendsTableViewDatasource.searchResult[indexPath.row]
        if let currentUser = ParseDbManager.shared.currentUser() {
            currentUser.friends!.append(chosenFiend)
            ParseDbManager.shared.bgUpdateQuizzer(quizzer: currentUser, completion: {

                [weak self] (bool, error) in
                guard error == nil else {
                    //TODO better errorhandling in this method
                    print(error)
                    return
                }

                self?.dismiss(animated: true)

            })

        }
        self.dismiss(animated: true)
    }

}

//MARK: SearchBarDelegate

extension MulitplayerSerachFriendsController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Seraching....")
        searchBar.resignFirstResponder()
        let searchString = searchBar.text!
        ParseDbManager.shared.bgFindQuizzers(containing: searchString, completion: {
            (quizzers, error) in

            guard error == nil else {
                //TODO implement better error handling in searchBarSearchButtonClicked
                print(error)
                return
            }
            if let quizzers = quizzers {
                print(quizzers)
                self.searchFriendsTableViewDatasource.searchResult = quizzers
                self.searchFriendsTableView.reloadData()
            } else {
                print("Quizzers was nil")
            }

        })
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
        searchBar.resignFirstResponder()
    }
}
