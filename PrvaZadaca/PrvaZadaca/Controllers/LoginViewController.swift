//
//  LoginViewController.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 08/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func login(_ sender: UIButton) {
        loginUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func loginUser() {
        let urlString = "https://iosquiz.herokuapp.com/api/session"
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let parameters: [String: Any] = [
                    "username": self.usernameField.text!,
                    "password": self.passwordField.text!
                ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject:
                    parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }

            URLSession.shared.dataTask(with: request) { (data, response, err) in
                if err != nil {
                    self.displayError(with: "Invalid request.")
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String : Any], let token = jsonDict["token"] as? String {
                            UserDefaults.standard.set(token, forKey: "accesToken")
                            print("Successfuly logged in with token: ", token)
                            DispatchQueue.main.async {
                                let vc = UINavigationController(rootViewController: QuizzesViewController())
                                vc.navigationItem.title = "QUIZ GAME"
                                self.view.window?.rootViewController = UINavigationController(rootViewController: QuizzesViewController())
                            }
                        } else {
                            self.displayError(with: "Invalid login parameters.")
                        }
                    } catch {
                        self.displayError(with: "Invalid token.")
                    }
                }
            }.resume()
        } else {
            print("Can't create URL.")
            self.displayError(with: "URL can't be reached.")
        }
    }
    
    func displayError(with text: String) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            self.errorLabel.text = text
        }
    }

}
