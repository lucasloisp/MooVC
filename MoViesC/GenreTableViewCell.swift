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
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let genreMovieNib = UINib(nibName: GenreMovieCollectionViewCell.identifier, bundle: nil)
        let identifier = GenreMovieCollectionViewCell.identifier
        moviesCollectionView.register(genreMovieNib, forCellWithReuseIdentifier: identifier)
    }

    func configure(for genre: String) {
        nameLabel.text = genre
        // TODO: Prepare the collection view for displaying movies
    }

}
