//
//  LoginViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-23.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {


    @IBOutlet weak var modalSubView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var loginOrSignupButton: UIButton!
    @IBOutlet weak var switchMode: UIButton!
    @IBOutlet weak var addProfilePicButton: UIButton!
    @IBOutlet weak var profilePicPreview: AvatarImageView!

    var loginMode = true
    var logInOrSignupInProgress = false
    var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.modalSubView.layer.borderWidth = 2
        self.modalSubView.layer.borderColor = UIColor.yellow.cgColor
        self.modalSubView.layer.cornerRadius = 10
        self.profilePicPreview.image = UIImage(named: "defaultUser")
        switchTologinMode()
    }


    @IBAction func addProfilePicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }


    @IBAction func loginOrSignup(_ sender: Any) {

        if isValidInput() && !logInOrSignupInProgress {
            if !logInOrSignupInProgress {
                logInOrSignupInProgress = true
                if loginMode {
                    logInUser()
                } else {
                    signupUser()
                }
            } else {
                print("Alreaty loggin in")
            }

        } else {
            Util.showSimpleAlert(presentingVc: self, title: "Invalid input!", message: "Check your input")
        }

    }

    @IBAction func abort(_ sender: Any) {
        self.dismiss(animated: true)
    }


    @IBAction func switchMode(_ sender: Any) {
        if loginMode {
            switchToSignupMode()
        } else {
            switchTologinMode()
        }
    }

    deinit {
//        print(self.delegate)
//        self.delegate?.didFinishAuthenticating()
        print("LoginViewController destroyed")
//        print(self)
    }
}

// MARK: Private methods

extension LoginViewController {

    fileprivate func switchTologinMode() {

        emailTextField.isHidden = true
        passwordConfirmTextField.isHidden = true
        addProfilePicButton.isHidden = true
        profilePicPreview.isHidden = true
        loginOrSignupButton.setTitle("Log in!", for: .normal)
        switchMode.setTitle("Or Sign up", for: .normal)
        loginMode = true

    }

    fileprivate func switchToSignupMode() {
        emailTextField.isHidden = false
        passwordConfirmTextField.isHidden = false
        addProfilePicButton.isHidden = false
        profilePicPreview.isHidden = false
        loginOrSignupButton.setTitle("Sign up!", for: .normal)
        switchMode.setTitle("Or Login", for: .normal)
        loginMode = false
    }

    fileprivate func isValidInput() -> Bool {
        if loginMode {
            return userNameTextField.text!.characters.count > 0 && passwordTextfield.text!.characters.count > 0
        } else {
            return userNameTextField.text!.characters.count > 3 &&
                    emailTextField.text!.characters.count > 4 &&
                    passwordTextfield.text!.characters.count > 4 &&
                    passwordConfirmTextField.text!.characters.count > 4 &&
                    passwordTextfield.text! == passwordConfirmTextField.text
            return true
        }

    }

    fileprivate func signupUser() {
        let userName = userNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextfield.text!
        let avatarImage = profilePicPreview.image!
        print(avatarImage)

        ParseDbManager.shared.bgRegisterNewQuizzer(username: userName, email: email, password: password, image: avatarImage, completion: {
            [unowned self] (bool, error) in
            guard error == nil else {
                print(error)
                //TODO Implement error handling in signupUser
                self.logInOrSignupInProgress = false
                return
            }

            print("User successfully signed up")
            self.dismiss(animated: true)
            self.delegate?.didFinishAuthenticating()

        })
    }

    fileprivate func logInUser() {
        let userName = userNameTextField.text!
        let password = passwordTextfield.text!
        ParseDbManager.shared.bgLoginQuizzer(username: userName, password: password, completion: {
            [unowned self] (quizzer, error) in
            guard error == nil else {
                print(error)
                //TODO Implement error handling in signupUser
                self.logInOrSignupInProgress = false
                return
            }
            print("User successfully logged in")
            self.dismiss(animated: true)
            self.delegate?.didFinishAuthenticating()
        })

    }


}


// MARK: UIImagePickerDelegate & NavigationControllerDelegate

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profilePicPreview.image = image
        picker.dismiss(animated: true)

    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}


protocol LoginViewControllerDelegate {
    func didFinishAuthenticating()
}

