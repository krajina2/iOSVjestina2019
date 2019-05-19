//
//  ResultsViewController.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 19/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsTableView: UITableView!
    var refreshControl: UIRefreshControl!
    var results: [Result]?
    var quizId: Int?
    
    convenience init(quizId: Int) {
        self.init()
        self.quizId = quizId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }

    func setupTableView() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCellReuseIdentifier")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ResultsViewController.refresh), for: UIControl.Event.valueChanged)
        resultsTableView.refreshControl = refreshControl
    }
    
    func fetchData() {
        if let id = quizId {
            ResultService().getResults(quizId: id, completion: { [weak self] (results, err) in
                if err != nil {
                    print("Couldn't fetch results!")
                    return
                }

                self?.results = results
                self?.refresh()
            })
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension ResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCellReuseIdentifier", for: indexPath) as! ResultTableViewCell
        
        if let result = results?[indexPath.row] {
            cell.setup(withResult: result)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
