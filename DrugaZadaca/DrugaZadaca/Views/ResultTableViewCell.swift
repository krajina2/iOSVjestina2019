//
//  ResultTableViewCell.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 19/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        userLabel.text = ""
        correctLabel.text = ""
        timeLabel.text = ""
    }
    
    func setup(withResult result: Result) {
        userLabel.text = "User ID: \(result.userId ?? 0)"
        correctLabel.text = "Correct Answers: \(result.noOfCorrect ?? 0)"
        timeLabel.text = "Time: \(result.time ?? 0)"
    }
    
}
