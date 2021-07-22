//
//  GenreTableViewCell.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    static let identifier = "GenreTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // Configure the view for the selected state
    }

    func configure(for genre: String) {
        nameLabel.text = genre
        // TODO: Prepare the collection view for displaying movies
    }

}
