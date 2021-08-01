//
//  GenreTableViewCell.swift
//  MoViesC
//
//  Created by Lucas Lois on 22/7/21.
//

import UIKit

class GenreTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    static let identifier = "GenreTableViewCell"

    var collectionViewOffset: CGFloat {
        get {
            return moviesCollectionView.contentOffset.x
        }

        set {
            moviesCollectionView.contentOffset.x = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let genreMovieNib = UINib(nibName: GenreMovieCollectionViewCell.identifier, bundle: nil)
        let genreMovieFooterNib = UINib(nibName: GenreMovieCollectionReusableView.identifier, bundle: nil)
        let identifier = GenreMovieCollectionViewCell.identifier
        moviesCollectionView.register(genreMovieNib, forCellWithReuseIdentifier: identifier)
        moviesCollectionView.register(genreMovieFooterNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GenreMovieCollectionReusableView.identifier)
    }

    func stopScrolling() {
        moviesCollectionView.setContentOffset(moviesCollectionView.contentOffset, animated: false)
    }

    func configure(for genre: String) {
        nameLabel.text = genre
        // TODO: Prepare the collection view for displaying movies
    }

}
