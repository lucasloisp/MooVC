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
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(for genre: String, showing poster: UIImage?) {
        nameLabel.text = genre
        posterImageView.image = poster
        // TODO: Prepare the collection view for displaying movies
    }

}
