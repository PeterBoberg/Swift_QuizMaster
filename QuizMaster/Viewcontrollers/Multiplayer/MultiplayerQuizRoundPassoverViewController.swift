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
        initUI()
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

// MARK: Private methods

extension MultiplayerQuizRoundPassoverViewController {

    fileprivate func initUI() {

        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.modalSubView.layer.borderWidth = 2
        self.modalSubView.layer.borderColor = UIColor.gray.cgColor
        self.modalSubView.layer.cornerRadius = 10

    }
}
