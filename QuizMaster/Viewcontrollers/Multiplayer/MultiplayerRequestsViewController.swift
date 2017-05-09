//
//  MultiplayerRequestsViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-28.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerRequestsViewController: UIViewController {


    @IBOutlet weak var matchesTableView: RoundEdgeTableView!
    @IBOutlet weak var requestsTableView: RoundEdgeTableView!

    let requeststTableViewDatasource = RequestsTableViewDatasource()
    let matchesTableViewDatasource = MatchesTableViewDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestsTableView.dataSource = requeststTableViewDatasource
        matchesTableView.dataSource = matchesTableViewDatasource
        requestsTableView.delegate = self
        matchesTableView.delegate = self
        matchesTableView.tableFooterView = UIView()
        requestsTableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadRequests()
        downloadMatches()
    }


}


// MARK: TableviewDelegate

extension MultiplayerRequestsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == requestsTableView {
            handleRequestsTableView(tableView: tableView, didSelectRowAt: indexPath)
        } else {
            handleMatcherTableView(tableView: tableView, didSelectRowAt: indexPath)
        }
    }
}

// MARK: Private methods

extension MultiplayerRequestsViewController {

    fileprivate func downloadRequests() {
        let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
        ParseDbManager.shared.bgFindIncomingRequestsFor(quizzer: currentQuizzer, completion: {
            [weak self](challenges, error) in

            guard error == nil else {
                print(error)
                return
            }

            if let challenges = challenges {
                self?.requeststTableViewDatasource.challenges = challenges
                self?.requestsTableView.reloadData()

            }
        })
    }

    fileprivate func downloadMatches() {
        let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
        ParseDbManager.shared.bgFindRunningMatchesFor(quizzer: currentQuizzer, completion: {
            [weak self] (matches, error) in
            guard error == nil else {
                //TODO better error handlin
                print(error)
                return
            }

            if let matches = matches {

                self?.matchesTableViewDatasource.currentMatches = matches
                self?.matchesTableView.reloadData()
            }
        })
    }

    fileprivate func handleRequestsTableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let chosenChallenge = requeststTableViewDatasource.challenges[indexPath.row]
        if let challenger = chosenChallenge.challenger, let challenged = chosenChallenge.challenged,
           let category = chosenChallenge.category {
            GameEngine.shared.createNewQuizMatch(category: category, challenger: challenger, challenged: challenged, completion: {
                (success, error) in
                guard error == nil else {
                    // TODO Better error handlning
                    print(error)
                    return
                }

                if success {
                    print("Created new Quizmatch")
                    ParseDbManager.shared.deleteQuizChallege(chosenChallenge, completion: {
                        [weak self] (success, error) in
                        self?.downloadMatches()
                        self?.downloadRequests()
                    })
                } else {
                    print("Did not create new quizmatch")
                }

            })
        } else {
            // TODO Better eror handling in MultiplayerRequestsViewController didSelectRowAt
            print("Could not retrieve challengre")
        }
    }

    fileprivate func handleMatcherTableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizMatch = matchesTableViewDatasource.currentMatches[indexPath.row]
        let startQuizVc = self.storyboard?.instantiateViewController(withIdentifier: "MultiplayerStartQuizViewController") as! MultiplayerStartQuizViewController
        startQuizVc.quizMatch = quizMatch
        self.navigationController?.pushViewController(startQuizVc, animated: true)
    }
}
