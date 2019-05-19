//
//  QuizTableSectionHeader.swift
//  DrugaZadaca
//
//  Created by Marko Krajina on 12/05/2019.
//  Copyright © 2019 Marko Krajina. All rights reserved.
//

import UIKit
import PureLayout

class QuizTableSectionHeader: UIView {

   var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "Section Title"
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.autoPinEdgesToSuperviewEdges()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(withCategory category: Category) {
        titleLabel.text = category.text
        titleLabel.backgroundColor = category.color
    }

}
