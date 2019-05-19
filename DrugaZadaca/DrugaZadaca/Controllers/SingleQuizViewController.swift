//
//  SingleQuizViewController.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 11/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class SingleQuizViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionScrollView: UIScrollView!
    @IBOutlet weak var quizImage: UIImageView!
    
    var quiz: Quiz?
    var correctAnswers = 0
    var currentQuestion = 0
    var startDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    convenience init(quiz: Quiz) {
        self.init()
        self.quiz = quiz
    }
    
    @IBAction func displayResults(_ sender: UIButton) {
        if let id = quiz?.id {
            let resultsViewController = ResultsViewController(quizId: id)
            navigationController?.pushViewController(resultsViewController, animated: true)
        }
    }
    
    func setup() {
        titleLabel.text = quiz?.title
        fetchImage()
        questionScrollView.isHidden = true
        setupScrollView()
    }
    
    func setupScrollView() {
        let stackView = UIStackView()
        questionScrollView.addSubview(stackView)
        
        questionScrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.autoSetDimension(.height, toSize: questionScrollView.frame.height)
        
        stackView.widthAnchor.constraint(greaterThanOrEqualTo: questionScrollView.widthAnchor).isActive = true
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.alignment = .fill
        
        if let count = quiz?.questions?.count {
            for i in 0..<count {
                if let questionView = Bundle.main.loadNibNamed("QuestionView", owner: nil, options: [:])?.first as? QuestionView {
                    
                    if let question = quiz?.questions?[i] {
                        questionView.questionLabel.text = question.question
                        questionView.setButtons(question: question)
                    }
                    
                    questionView.delegate = self
                    questionView.translatesAutoresizingMaskIntoConstraints = false
                    questionView.widthAnchor.constraint(equalToConstant: questionView.frame.width).isActive = true
                    stackView.addArrangedSubview(questionView)
                }
            }
        }
    }
    
    func scrollQuestion() {
        DispatchQueue.main.async {
            self.questionScrollView.setContentOffset(CGPoint(x: self.questionScrollView.contentOffset.x + self.questionScrollView.frame.width + 32, y: 0), animated: true)
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.questionScrollView.isHidden = false
            self.questionScrollView.setContentOffset(CGPoint(x: self.questionScrollView.contentOffset.x + 16, y: 0), animated: false)
            sender.isHidden = true
        }
        
        startDate = Date()
    }
    
    func fetchImage() {
        let imageService = ImageService()
        
        if let image = quiz?.image {
            imageService.fetchImage(imageUrl: image) { (image) in
                DispatchQueue.main.async {
                    self.quizImage.image = image
                }
            }
        }
    }

}

extension SingleQuizViewController: QuestionViewDelegate {
    func correctAnswer() {
        self.correctAnswers += 1
    }
    
    func nextQuestion() {
        currentQuestion += 1
        
        if let count = quiz?.questions!.count {
            if currentQuestion >= count {
                print("Number of correct answers: \(correctAnswers)/\(count)")
                print("Time elapsed: \(self.startDate!.timeIntervalSinceNow * -1)")
                sendResult()
            }
        }
        
        self.scrollQuestion()
    }
    
    func sendResult() {
        let resultService = ResultService()
        resultService.sendResult(completion: { (response, error) in
            if error != nil {
                self.showAlert()
            }
            
            if let response = response {
                switch response {
                case .ok:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    self.showAlert()
                }
            }
        }, quiz: self.quiz!, correctAnswers: self.correctAnswers, time: self.startDate!.timeIntervalSinceNow * -1)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "An error occured while sending the result.", preferredStyle: .alert)
        
        let sendAgain = UIAlertAction(title: "Send again", style: .default) { (action:UIAlertAction) in
            self.sendResult()
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("Canceled!")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addAction(sendAgain)
        alertController.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
