//
// Created by Kung Peter on 2017-04-08.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CategoryViewController: UIViewController {


    @IBOutlet weak var categoryTableView: UITableView!

    let tableviewDatasource = CategoryTableViewDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = tableviewDatasource

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

}

// MARK: TableViewDelegate

extension CategoryViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let destinationController = self.storyboard!.instantiateViewController(withIdentifier: "EasyMediumHardController") as! EasyMeduimHardViewController
        destinationController.currentCategory = tableviewDatasource.getCategory(number: indexPath.row)
        destinationController.currentBgImage = UIImage(named: tableviewDatasource.bigImages[indexPath.row])
        self.navigationController!.pushViewController(destinationController, animated: true)
    }


}


