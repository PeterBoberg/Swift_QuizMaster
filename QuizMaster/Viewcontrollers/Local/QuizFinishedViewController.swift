//
//  QuizFinishedViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-12.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class QuizFinishedViewController: UIViewController {

    @IBOutlet weak var modalSubView: UIView!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var totalCorrectLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!


    var navController: UINavigationController!
    var quizResult: QuizRoundResult!
    var currentPlayer: QuizPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    @IBAction func goBackToRoot(_ sender: Any) {

        LocalDbManager.shared.addNewQuizResult(forPlayer: currentPlayer, quizRoundResult: quizResult, completion: {
            (error) in

            if error != nil {
                print(error)
            }
            self.dismiss(animated: true)
            self.navController.popToRootViewController(animated: true)
        })

    }

    deinit {
        print("QuizFinishedViewController destroyed")
    }
}

//MARK: private methods

extension QuizFinishedViewController {

    fileprivate func initUI() {
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.modalSubView.layer.borderWidth = 2
        self.modalSubView.layer.borderColor = UIColor.yellow.cgColor
        self.modalSubView.layer.cornerRadius = 10
        self.correctLabel.text = quizResult.correctGuesses
        self.incorrectLabel.text = quizResult.incorrectGuesses
        self.totalCorrectLabel.text = quizResult.correctGuesses
        self.totalLabel.text = quizResult.totalQuestions

    }
}
