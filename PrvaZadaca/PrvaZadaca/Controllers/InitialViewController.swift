//
//  InitialViewController.swift
//  PrvaZadaca
//
//  Created by Marko Krajina on 08/04/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBAction func dohvati(_ sender: UIButton) {
        fetchQuizzes()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "accesToken")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            let vc = LoginViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func fetchQuizzes() {
        let quizService = QuizService()
        
        quizService.fetchQuizes { (quizzes, error) in
            if error != nil {
                self.errorLabel.isHidden = false
            }
            
            if let quizzes = quizzes {
                let result = self.countNumberOfOccurences(for: "NBA", in: quizzes)
                let randomQuiz = Int.random(in: 0..<quizzes.count)
                
                DispatchQueue.main.async {
                    self.funFactLabel.text = "Number of questions with string 'NBA' is \(result)"
                    self.titleLabel.text = quizzes[randomQuiz].title
                    self.titleLabel.backgroundColor = quizzes[randomQuiz].category?.color
                }
                
                self.fetchImage(quiz: quizzes[randomQuiz])
                self.showQuestion(quiz: quizzes[randomQuiz])
            }
        }
    }
    
    func fetchImage(quiz: Quiz) {
        let imageService = ImageService()
        
        if let image = quiz.image {
            imageService.fetchImage(imageUrl: image) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.backgroundColor = quiz.category?.color
                }
            }
        }
    }
    
    func showQuestion(quiz: Quiz) {
        DispatchQueue.main.async {
            if let questionView = Bundle.main.loadNibNamed("QuestionView", owner: nil, options: [:])?.first as? QuestionView {
                let randomQuestion = Int.random(in: 0..<(quiz.questions?.count ?? 0))
                if let question = quiz.questions?[randomQuestion] {
                    self.viewContainer.addSubview(questionView)
                    questionView.questionLabel.text = question.question
                    questionView.setButtons(question: question)
                }
            }
        }
    }
    
    func countNumberOfOccurences(for text: String, in array: [Quiz]) -> Int {
        var result = 0
        
        array.forEach { (quiz) in
            let filtered = quiz.questions?.filter({ (question) -> Bool in
                (question.question?.contains(text))!
            })
            
            result += filtered?.count ?? 0
        }
        
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}
