//
//  MultiplayerRequestsViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-28.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import Alamofire

class MultiplayerRequestsViewController: UIViewController {


    @IBOutlet weak var matchesTableView: RoundEdgeTableView!
    @IBOutlet weak var requestsTableView: RoundEdgeTableView!


    let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
    let dispatchGroup = DispatchGroup()
    let requestsTableViewDatasource = RequestsTableViewDatasource()
    let matchesTableViewDatasource = MatchesTableViewDatasource()

    lazy var requestsTableViewRefreshControl: UIRefreshControl = {
        let refeshControl = UIRefreshControl()
        refeshControl.addTarget(self, action: #selector(updateTableViews(refreshControl:)), for: .valueChanged)
        return refeshControl
    }()

    lazy var matchesTableViewRefreshControl: UIRefreshControl = {
        let refeshControl = UIRefreshControl()
        refeshControl.addTarget(self, action: #selector(updateTableViews(refreshControl:)), for: .valueChanged)
        return refeshControl
    }()


    // MARK: lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        requestsTableView.dataSource = requestsTableViewDatasource
        matchesTableView.dataSource = matchesTableViewDatasource
        requestsTableView.delegate = self
        matchesTableView.delegate = self
        matchesTableView.tableFooterView = UIView()
        requestsTableView.tableFooterView = UIView()
        requestsTableView.addSubview(requestsTableViewRefreshControl)
        matchesTableView.addSubview(matchesTableViewRefreshControl)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableViews()
    }
}


// MARK: TableviewDelegate

extension MultiplayerRequestsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == requestsTableView {
            handleRequestsTableView(tableView: tableView, didSelectRowAt: indexPath)
        } else {
            handleMatchesTableView(tableView: tableView, didSelectRowAt: indexPath)
        }
    }
}

// MARK: Private methods

extension MultiplayerRequestsViewController {

    @objc fileprivate func updateTableViews(refreshControl: UIRefreshControl? = nil) {
        let progressVc = getProgressIndicatorViewController()
        self.present(progressVc, animated: true)
        downloadRequests()
        downloadMatches()

        dispatchGroup.notify(queue: .main, execute: {
            [unowned self] in
            progressVc.dismiss(animated: true)
            refreshControl?.endRefreshing()
        })
    }

    fileprivate func downloadRequests() {
        dispatchGroup.enter()
        let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
        ParseDbManager.shared.bgFindIncomingRequestsFor(quizzer: currentQuizzer, completion: {
            [weak self](challenges, error) in
            self?.dispatchGroup.leave()
            guard error == nil else {
                print(error)
                return
            }

            if let challenges = challenges {
                self?.requestsTableViewDatasource.challenges = challenges
                self?.requestsTableView.reloadData()

            }
        })
    }

    fileprivate func downloadMatches() {
        dispatchGroup.enter()
        let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
        ParseDbManager.shared.bgFindRunningMatchesFor(quizzer: currentQuizzer, completion: {
            [weak self] (matches, error) in
            self?.dispatchGroup.leave()
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

        let chosenChallenge = requestsTableViewDatasource.challenges[indexPath.row]
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
            // TODO Better error handling in MultiplayerRequestsViewController didSelectRowAt
            print("Could not retrieve challengre")
        }
    }

    fileprivate func handleMatchesTableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizMatch = matchesTableViewDatasource.currentMatches[indexPath.row]

        ParseDbManager.shared.bgCreateNewQuizzerLocationFor(quizMatch: quizMatch, quizzer: currentQuizzer, completion: {
            (success, error) in
            if error != nil {
                print(error)
            }

            let startQuizVc = self.storyboard?.instantiateViewController(withIdentifier: "MultiplayerStartQuizViewController") as! MultiplayerStartQuizViewController
            startQuizVc.quizMatch = quizMatch
            self.navigationController?.pushViewController(startQuizVc, animated: true)

        })

    }
}
