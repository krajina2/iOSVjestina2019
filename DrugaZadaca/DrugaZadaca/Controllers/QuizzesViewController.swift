//
//  QuizzesViewController.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 11/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class QuizzesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var quizzes: [Quiz]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: "quizCellReuseIdentifier")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QuizzesViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        let tableFooter = QuizTableFooter(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        tableView.tableFooterView = tableFooter
    }
    
    func fetchData() {
        QuizService().fetchQuizes { [weak self] (quizzes, err) in
            if err != nil {
                print("Couldn't fetch quizzes!")
                return
            }
            
            self?.quizzes = quizzes
            self?.refresh()
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func quiz(atIndex index: Int, inSection section: Int) -> Quiz? {
        guard let quizzes = quizzes else {
            return nil
        }
        
        return quizzes.filter({ (quiz) -> Bool in
            quiz.category == Category.getCategory(for: section)
        })[index]
    }
    
    func quizzes(withCategory category: Category) -> Int {
        return quizzes?.filter({ (quiz) -> Bool in
            quiz.category == category
        }).count ?? 0
    }

}

extension QuizzesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let quiz = quiz(atIndex: indexPath.row, inSection: indexPath.section) {
            let singleQuizViewController = SingleQuizViewController(quiz: quiz)
            navigationController?.pushViewController(singleQuizViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = QuizTableSectionHeader()
        
        if let category = Category.getCategory(for: section) {
            header.setup(withCategory: category)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
}

extension QuizzesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quizCellReuseIdentifier", for: indexPath) as! QuizTableViewCell
        
        if let quiz = quiz(atIndex: indexPath.row, inSection: indexPath.section) {
            cell.setup(withQuiz: quiz)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let category = Category.getCategory(for: section) {
            return quizzes(withCategory: category)
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }
    
}
