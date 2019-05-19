//
//  QuestionView.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 08/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

protocol QuestionViewDelegate: class {
    func nextQuestion()
    func correctAnswer()
}

class QuestionView: UIView {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    var question: Question?
    weak var delegate: QuestionViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setButtons(question: Question) {
        self.question = question
        
        DispatchQueue.main.async {
            for (index, button) in self.answerButtons.enumerated() {
                button.setTitle(question.answers?[index], for: .normal)
                button.addTarget(self, action: #selector(self.setAnswerColor), for: .touchUpInside)
            }
        }
    }
    
    @objc func setAnswerColor(sender: UIButton) {
        if let correct = question?.correctAnswer {
            if correct == answerButtons.firstIndex(of: sender) {
                sender.backgroundColor = .green
                delegate?.correctAnswer()
            } else {
                sender.backgroundColor = .red
            }
        }
        
        delegate?.nextQuestion()
    }
    
}
