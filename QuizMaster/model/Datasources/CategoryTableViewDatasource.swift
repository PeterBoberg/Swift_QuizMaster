//
// Created by Kung Peter on 2017-04-08.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit

class CategoryTableViewDatasource: NSObject, UITableViewDataSource {

    let allCategories: [Category] = [.mythology, .geography, .history, .scienceNature]
    private let images = ["mythology", "geography", "history", "scienceNature"]
    let bigImages = ["mythologyBig", "geographyBig", "historyBig", "scienceNatureBig"]

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        cell.categoryLabel.text = allCategories[indexPath.row].rawValue
        cell.categoryImageView.image = UIImage(named: images[indexPath.row])
        return cell
    }

    public func getCategory(number: Int) -> Category {
        return allCategories[number]
    }


}
