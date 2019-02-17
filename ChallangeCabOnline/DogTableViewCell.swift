//
//  DogTableViewCell.swift
//  ChallangeCabOnline
//
//  Created by Robert Andersson on 2019-02-17.
//  Copyright © 2019 Kroppe. All rights reserved.
//

import UIKit

class DogTableViewCell: UITableViewCell {

    @IBOutlet weak var dogCellLabel: UILabel!
    @IBOutlet weak var dogCellImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
