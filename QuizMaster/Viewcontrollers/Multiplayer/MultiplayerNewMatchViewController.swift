//
//  MultiplayerNewMatchViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-27.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class MultiplayerNewMatchViewController: UIViewController {
    
    
    var challengedQuizzer: Quizzer!

    @IBOutlet weak var challengedNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        challengedNameLabel.text = challengedQuizzer?.username

    }

    @IBAction func requestNewQuizMatch(_ sender: UIButton) {
        let categoryVc = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        categoryVc.challangedQuizzer = challengedQuizzer
        self.navigationController?.pushViewController(categoryVc, animated: true)
    }

    
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
