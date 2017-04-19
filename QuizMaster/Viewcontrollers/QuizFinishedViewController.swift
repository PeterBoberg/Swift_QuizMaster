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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func goBackToRoot(_ sender: Any) {
        self.dismiss(animated: true)
        navController.popToRootViewController(animated: true)
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
