//
//  QuizTableViewCell.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 11/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {

    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
    
    func setup(withQuiz quiz: Quiz) {
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
        fetchImage(quiz: quiz)
    }
    
    func fetchImage(quiz: Quiz) {
        let imageService = ImageService()
        
        if let image = quiz.image {
            imageService.fetchImage(imageUrl: image) { (image) in
                DispatchQueue.main.async {
                    self.quizImage.image = image
                }
            }
        }
    }
    
}
