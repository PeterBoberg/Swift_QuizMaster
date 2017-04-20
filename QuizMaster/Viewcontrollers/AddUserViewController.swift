//
//  AddUserViewController.swift
//  QuizMaster
//
//  Created by Kung Peter on 2017-04-20.
//  Copyright © 2017 PeterBobergAB. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    var navController: UINavigationController!
    var delegate: AddUserViewControllerDelegate?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var modalSubView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.modalSubView.layer.borderWidth = 2
        self.modalSubView.layer.borderColor = UIColor.yellow.cgColor
        self.modalSubView.layer.cornerRadius = 10
    }


    @IBAction func addProfilePic(_ sender: Any) {
        print("Add profile pic")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)

    }

    @IBAction func done(_ sender: Any) {
        if isValidInput() {
            if let delegate = delegate {
                let name = nameTextField.text!
                delegate.addUserViewController(didFinishEnterUserInfoWithName: name, image: nil)
                dismiss(animated: true)
            }
        } else {
            showalert(title: "Sorry!", message: "You must provide a name for your self!")
        }

    }

    @IBAction func abort(_ sender: Any) {
        if let delegate = delegate {
            delegate.addUserViewControllerCancelled()
        }
        dismiss(animated: true)
    }

}

//MARK: Private Methods

extension AddUserViewController {

    fileprivate func showalert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK!", style: .default))
        self.present(alertController, animated: true)
    }

    fileprivate func isValidInput() -> Bool {
        return nameTextField.text != nil && nameTextField.text != ""
    }
}

// MARK: UIImagePickerControllerDelegate

extension AddUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        if isValidInput() {
            print("Is valid input")
            if let delegate = delegate {
                var avatarImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                let name = nameTextField.text
                delegate.addUserViewController(didFinishEnterUserInfoWithName: name!, image: avatarImage)
            }

        } else {
            showalert(title: "Sorry!", message: "You must provide a name for your self!")
        }
        dismiss(animated: true)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        if let delegate = delegate {
            delegate.addUserViewControllerCancelled()
        }
    }

}


protocol AddUserViewControllerDelegate {

    func addUserViewController(didFinishEnterUserInfoWithName name: String, image: UIImage?)

    func addUserViewControllerCancelled()
}

