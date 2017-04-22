//
// Created by Kung Peter on 2017-04-08.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CategoryViewController: UIViewController {

    let tableviewDatasource = CategoryTableViewDatasource()
    var currentPlayer: QuizPlayer!

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

        let easyMediumHardVc = self.storyboard!.instantiateViewController(withIdentifier: "EasyMediumHardController") as! EasyMeduimHardViewController
        easyMediumHardVc.currentCategory = tableviewDatasource.getCategory(number: indexPath.row)
        easyMediumHardVc.currentBgImage = UIImage(named: tableviewDatasource.bigImages[indexPath.row])
        easyMediumHardVc.currentPlayer = self.currentPlayer
        self.navigationController!.pushViewController(easyMediumHardVc, animated: true)
    }


}


