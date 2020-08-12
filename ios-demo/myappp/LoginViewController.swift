	//
//  LoginViewController.swift
//  myappp
//
//  Created by lucian on 2020/8/6.
//  Copyright © 2020年 lucian. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utils.styleView(image: "login", viewController: self)
        Utils.styleTextField(textField: usernameTextField)
        Utils.styleTextField(textField: passwordTextField)
        Utils.styleFilledButton(button: loginButton)
        usernameTextField.becomeFirstResponder()
        passwordTextField.isSecureTextEntry = true
        
    }
    
    func validateFields() -> String? {
        if usernameTextField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(
                in: .whitespacesAndNewlines) == "" {
            return "用户名密码不能为空"
        }
        return nil
    }
    
    func showError(error: String) {
        errorLabel.alpha = 1
        errorLabel.text = error
        /*
        UIView.transition(errorLabel, duration: 1, options: [.TransitionCrossDissolve], animations: {
            errorLabel.alpha = 1
            errorLabel.text = error
            }, completion: {(_) in
                errorLabel.alpha = 0
                errorLabel.text = nil
        })
         */
    }
    
    func navigateToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    

    @IBAction func loginTapped(_ sender: AnyObject) {
        let error = self.validateFields()
        if error != nil {
            self.showError(error: error!)
        } else {
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if username != "admin" || password != "123456" {
                self.showError(error: "用户名或者密码错误")
            } else {
                self.navigateToHome()
            }
            
        }
    }
}
			
