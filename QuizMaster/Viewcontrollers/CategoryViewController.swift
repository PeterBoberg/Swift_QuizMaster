//
// Created by Kung Peter on 2017-04-08.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CategoryViewController: UIViewController {

    let tableviewDatasource = CategoryTableViewDatasource()
    var currentPlayer: QuizPlayer?
    var challangedQuizzer: Quizzer?

    @IBOutlet weak var categoryTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = tableviewDatasource
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    deinit {
        print("CategoryViewController destroyed")
    }

}

// MARK: TableViewDelegate

extension CategoryViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // TODO clean up this UITableViewDelegate in CategoryViewController
        if let currentPlayer = currentPlayer {
            let easyMediumHardVc = self.storyboard!.instantiateViewController(withIdentifier: "EasyMediumHardController") as! EasyMeduimHardViewController
            easyMediumHardVc.currentCategory = tableviewDatasource.getCategory(number: indexPath.row)
            easyMediumHardVc.currentBgImage = UIImage(named: tableviewDatasource.bigImages[indexPath.row])
            easyMediumHardVc.currentPlayer = self.currentPlayer
            self.navigationController!.pushViewController(easyMediumHardVc, animated: true)

        } else if let challengedQuizzer = challangedQuizzer {
            let currentQuizzer = ParseDbManager.shared.currentQuizzer()
            if let currentQuizzer = currentQuizzer {
                let category = tableviewDatasource.allCategories[indexPath.row]
                ParseDbManager.shared.sendQuizChallengeBetween(challenger: currentQuizzer, challenged: challengedQuizzer, catgory: category, completion: {
                    [weak self] (success, error) in
                    guard error == nil else {
                        print(error)
                        return
                    }
                    if success {
                        print("Successfully sent challenge to \(challengedQuizzer.username)")
                    }

                })

            }
        }

    }


}


