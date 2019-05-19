//
//  QuizTableFooter.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 11/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class QuizTableFooter: UIView {

    var logoutButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        logoutButton = UIButton()
        logoutButton.backgroundColor = .lightGray
        logoutButton.titleLabel?.textAlignment = .center
        logoutButton.setTitle("Logout", for: .normal)
        self.addSubview(logoutButton)
        logoutButton.autoSetDimension(.height, toSize: 50)
        logoutButton.autoSetDimension(.width, toSize: 100)
        logoutButton.autoAlignAxis(.vertical, toSameAxisOf: self)
        logoutButton.addTarget(self, action: #selector(self.logoutUser), for: .touchUpInside)
    }
    
    @objc func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "accesToken")
        UserDefaults.standard.synchronize()
        
        let loginVC = LoginViewController()
        window?.rootViewController = loginVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
