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
    var progressViewController: ProgressIndicatorViewController!

    let quizHistoryTableViewDatasource = QuizHistoryTableViewDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()
        progressViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProgressIndicatorViewController") as! ProgressIndicatorViewController
        progressViewController.modalPresentationStyle = .overCurrentContext
        progressViewController.modalTransitionStyle = .crossDissolve

        quizHistoryTableView.dataSource = quizHistoryTableViewDatasource
        downloadMatchHistory()

    }

}

//MARK: Prinvate Methods

extension MultiplayerQuizHistoryViewController {

    fileprivate func downloadMatchHistory() {

        self.present(progressViewController, animated: true)

        GameEngine.shared.findFinishedMatcesFor(quizzer: currentQuizzer, completion: {
            [unowned self] (quizMatches, error) in

            self.progressViewController.dismiss(animated: true)

            guard error == nil else {
                //TODO better error handling
                print(error)
                return
            }
             if let quizMatches = quizMatches {
                 self.quizHistoryTableViewDatasource.quizMatches = quizMatches
                 self.quizHistoryTableView.reloadData()
             }

        })

    }
}