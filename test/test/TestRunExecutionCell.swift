//
//  TestRunExecutionCell.swift
//  test
//
//  Created by PSU2 on 5/31/17.
//  Copyright © 2017 Devan Cakebread. All rights reserved.
//

import UIKit

class TestRunExecutionCell: UITableViewCell {

    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expectedResultsText: UITextView!
    @IBOutlet weak var notesText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
