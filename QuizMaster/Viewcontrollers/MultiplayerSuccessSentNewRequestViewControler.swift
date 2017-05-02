//
//  MultiplayerSuccessSentNewRequestViewControler.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-27.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerSuccessSentNewRequestViewControler: UIViewController {
    var challengedQuizzer: Quizzer!
    var navController: UINavigationController?

    @IBOutlet weak var challengedNameLabel: UILabel!
    @IBOutlet weak var modalSubView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.modalSubView.layer.borderWidth = 2
        self.modalSubView.layer.borderColor = UIColor.yellow.cgColor
        self.modalSubView.layer.cornerRadius = 10
        challengedNameLabel.text = challengedQuizzer.username

    }


    @IBAction func backToStartViewController(_ sender: Any) {
        if let viewControllers = self.navController?.viewControllers {
            let vcToJumpTo = viewControllers[viewControllers.count - 3]
            self.dismiss(animated: true)
            self.navController?.popToViewController(vcToJumpTo, animated: true)
        }
    }

    deinit {
        print("MultiplayerSuccessSentNewRequestViewControler destroyed")
    }
}
