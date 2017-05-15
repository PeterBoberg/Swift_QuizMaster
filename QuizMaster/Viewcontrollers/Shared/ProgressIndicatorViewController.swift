//
//  ProgressIndicatorViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-05-09.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class ProgressIndicatorViewController: UIViewController {

    @IBOutlet weak var progressLoaderView: ProgressLoaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressLoaderView.startAnimation()
    }


    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        progressLoaderView.stopAnimation()
        super.dismiss(animated: flag, completion: completion)
    }

    deinit {
        print("ProgressIndicatorViewController destroyed")
    }
}
