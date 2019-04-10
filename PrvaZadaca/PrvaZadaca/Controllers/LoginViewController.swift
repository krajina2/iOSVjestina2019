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
        login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func login() {
        let urlString = "​https://iosquiz.herokuapp.com/api/session"
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let parameters: [String: Any] = [
                    "username": self.usernameField.text!,
                    "password": self.passwordField.text!
                ]
            
            print(parameters)

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject:
                    parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }

            URLSession.shared.dataTask(with: request) { (data, response, err) in
                if err != nil {
                    DispatchQueue.main.async {
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "Invalid login parameters."
                    }
                    print("Wrong username or password.")
                    return
                }
                
                if let data = data {
                    do {
                        let token = try JSONDecoder().decode(String.self, from: data)
                        UserDefaults.standard.set(token, forKey: "accesToken")
                        print("Successfuly logged in with token: ", token)
                    } catch let error {
                        DispatchQueue.main.async {
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "Invalid token."
                        }
                        
                        print("Couldn't parse token.", error)
                    }
                }
                
                let vc = InitialViewController()
                self.present(vc, animated: true, completion: nil)
            }.resume()
        } else {
            DispatchQueue.main.async {
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Invalid login parameters."
            }
        }
    }

}
