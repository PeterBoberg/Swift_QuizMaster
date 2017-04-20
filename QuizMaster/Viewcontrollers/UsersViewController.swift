//
//  UsersViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-20.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var usersCollectionView: UICollectionView!

    let userCollectionViewDataSource = UserCollectionViewDatasource()
    override func viewDidLoad() {
        super.viewDidLoad()
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = userCollectionViewDataSource

    }

}

// MARK: UICollectionViewDelegate
extension UsersViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

}

