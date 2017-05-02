//
//  RoundEdgeTableView.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-02.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class RoundEdgeTableView: UITableView {


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.yellow.cgColor
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)

    }


}
