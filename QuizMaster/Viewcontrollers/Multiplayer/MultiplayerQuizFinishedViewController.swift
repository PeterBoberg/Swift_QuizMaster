//
//  MultiplayerQuizFinishedViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-04.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerQuizFinishedViewController: UIViewController {

    // Set by presentingViewController
    var navController: UINavigationController!
    var quizFinishedResult: QuizFinishedResult!

    @IBOutlet weak var modalSubView: UIView!
    @IBOutlet weak var challengedNameLabel: UILabel!
    @IBOutlet weak var challengerNameLabel: UILabel!
    @IBOutlet weak var challengerCorrectGuessesLabel: UILabel!
    @IBOutlet weak var challengerIncorrectGuessesLabel: UILabel!
    @IBOutlet weak var challengedCorrectGuessesLabel: UILabel!
    @IBOutlet weak var challengedIncorrectLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        populateLabels()

    }

  
    @IBAction func goBack(_ sender: CircularButton) {
        self.dismiss(animated: true, completion: {
            [unowned self] in
            self.navController.popToRootViewController(animated: true)
        })
    }

    private func populateLabels() {

        challengerNameLabel.text = quizFinishedResult.challengerName
        challengedNameLabel.text = quizFinishedResult.challengedName
        challengerCorrectGuessesLabel.text = quizFinishedResult.challengerCorrectGuesses
        challengerIncorrectGuessesLabel.text = quizFinishedResult.challengerIncorrectGuesses
        challengedCorrectGuessesLabel.text = quizFinishedResult.challengedCorrectGuesses
        challengedIncorrectLabel.text = quizFinishedResult.challengedIncorrectGuesses
        winnerLabel.text = quizFinishedResult.winner
    }

    private func initUI() {
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.modalSubView.layer.borderWidth = 2
        self.modalSubView.layer.borderColor = UIColor.gray.cgColor
        self.modalSubView.layer.cornerRadius = 10
    }

}
