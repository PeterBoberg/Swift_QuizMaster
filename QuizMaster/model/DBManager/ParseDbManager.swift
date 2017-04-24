//
// Created by Kung Peter on 2017-04-23.
// Copyright (c) 2017 PeterBobergAB. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ParseDbManager {

    static let shared = ParseDbManager()

    private init() {
    }

    func bgRegisterNewQuizzer(username: String,
                              email: String,
                              password: String,
                              image: UIImage,
                              completion: ((Bool, NSError?) -> Void)?) {


        let newQuizzer = Quizzer()
        newQuizzer.username = username
        newQuizzer.email = email
        newQuizzer.password = password
        newQuizzer.avatarImage = PFFile(name: "\(username)_avatarImg.jpg", data: UIImageJPEGRepresentation(image, 1.0)!)

        newQuizzer.signUpInBackground(block: {
            (sucess, error) in

            guard error == nil else {
                completion?(false, error as! NSError)
                return
            }
            completion?(true, nil)
        })

    }

    func bgLoginQuizzer(username: String, password: String, completion: ((Quizzer?, Error?) -> Void)?) {

        PFUser.logInWithUsername(inBackground: username, password: password, block: {
            (pfUser, error) in
            print("inside compl handl")
            guard  error == nil else {
                completion?(nil, error)
                return
            }
            completion?(pfUser as! Quizzer, error)
        })
    }

    func currentUser() -> Quizzer? {
        return PFUser.current() as! Quizzer
    }

    func logOutCurrentUser() {
        PFUser.logOutInBackground()
    }

    func currentUserIsLoggedIn() -> Bool {
        return PFUser.current() != nil
    }


}
