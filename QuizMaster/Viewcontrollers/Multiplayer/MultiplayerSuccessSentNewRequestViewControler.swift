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
