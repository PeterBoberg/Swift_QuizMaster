//
//  MultiplayerQuizRoundPassoverViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-04.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerQuizRoundPassoverViewController: UIViewController {

    // Set by presenting ViewController
    var navController: UINavigationController!
    var quizPassoverResult: QuizPassoverResult!

    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var correctAnswersLabel: UILabel!

    @IBOutlet weak var modalSubView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        opponentNameLabel.text = quizPassoverResult.challengerName
        correctAnswersLabel.text = quizPassoverResult.correctAnswers
    }


    @IBAction func goBack(_ sender: CircularButton) {
        self.dismiss(animated: true, completion: {
            [unowned self] in
            self.navController.popToRootViewController(animated: true)
        })

    }

}
