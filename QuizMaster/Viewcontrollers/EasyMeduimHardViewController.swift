//
//  EasyMeduimHardViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-09.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class EasyMeduimHardViewController: UIViewController {

    var currentCategory: Category? = nil
    var currentBgImage: UIImage? = nil
    var currentPlayer: QuizPlayer? = nil

    @IBOutlet weak var bgImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.image = currentBgImage
        self.navigationController?.title = "Choose difficulty"

    }


    @IBAction func startQuiz(_ sender: UIButton) {

        let startGameController = self.storyboard!.instantiateViewController(withIdentifier: "StartQuizViewController") as! StartQuizViewController
        startGameController.category = currentCategory
        startGameController.currentPlayer = self.currentPlayer

        switch sender.tag {

        case 1:
            startGameController.difficulty = Difficulty.easy
            break
        case 2:
            startGameController.difficulty = Difficulty.medium
            break
        case 3:
            startGameController.difficulty = Difficulty.hard
            break
        default:
            startGameController.difficulty = Difficulty.easy
        }
        self.navigationController!.pushViewController(startGameController, animated: true)
    }
    deinit {
        print("EasyMeduimHardViewController destroyed")
    }

}
