//
//  QuestionView.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 08/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setButtons(question: Question) {
        DispatchQueue.main.async {
            for (index, button) in self.answerButtons.enumerated() {
                button.setTitle(question.answers?[index], for: .normal)
                button.setBackgroundColor(color: .red, forState: .highlighted)
            }
            
            if let answer = question.correctAnswer {
                self.answerButtons?[answer].setBackgroundColor(color: .green, forState: .highlighted)
            }
        }
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
