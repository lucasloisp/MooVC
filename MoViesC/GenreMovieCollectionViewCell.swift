//
//  GenreMovieCollectionViewCell.swift
//  MoViesC
//
//  Created by December on 23/7/21.
//

import UIKit

class GenreMovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "GenreMovieCollectionViewCell"

    @IBOutlet weak var movieNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String) {
        movieNameLabel.text = name
    }

}
