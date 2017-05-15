//
//  MultiplayerQuizHistoryViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-06.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerQuizHistoryViewController: UIViewController {

    @IBOutlet weak var quizHistoryTableView: RoundEdgeTableView!

    let currentQuizzer = ParseDbManager.shared.currentQuizzer()!
    let quizHistoryTableViewDatasource = QuizHistoryTableViewDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()
        quizHistoryTableView.delegate = self
        quizHistoryTableView.dataSource = quizHistoryTableViewDatasource
        quizHistoryTableView.tableFooterView = UIView()
        downloadMatchHistory()
    }

}

//MARK: Private Methods

extension MultiplayerQuizHistoryViewController {

    fileprivate func downloadMatchHistory() {

        let progressVc = getProgressIndicatorViewController()
        self.present(progressVc, animated: true)

        GameEngine.shared.findFinishedMatcesFor(quizzer: currentQuizzer, completion: {
            [unowned self] (quizMatches, error) in

            progressVc.dismiss(animated: true)

            guard error == nil else {
                //TODO better error handling
                print(error)
                return
            }
            if let quizMatches = quizMatches {
                self.quizHistoryTableViewDatasource.quizMatches = quizMatches
                self.quizHistoryTableView.reloadData()
            } else {
                print("Quizmatches was nil")
            }
        })

    }
}

// MARK: TableviewDelegate

extension MultiplayerQuizHistoryViewController: UITableViewDelegate {


    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        let quizMatch = quizHistoryTableViewDatasource.quizMatches[indexPath.row]
        let mapVc = self.storyboard?.instantiateViewController(withIdentifier: "MultiplayerMapViewController") as! MultiplayerMapViewController
        mapVc.quizMatch = quizMatch
        self.navigationController?.pushViewController(mapVc, animated: true)
    }

}