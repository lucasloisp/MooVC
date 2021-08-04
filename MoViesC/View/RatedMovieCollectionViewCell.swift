//
//  RatedMovieCollectionViewCell.swift
//  MoViesC
//
//  Created by Lucas Lois on 27/7/21.
//

import UIKit

class RatedMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var posterOverlayView: UIView!

    static let identifier: String = "RatedMovieCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 16

        if !posterImageView.isHidden {
            addAnOverlayToTheImageView()
        }
    }

    func configureAsLoading() {
        posterImageView.isHidden = true
        nameLabel.isHidden = true
        ratingStackView.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func configure(name: String, poster: URL?, starCount: Int?) {
        self.activityIndicatorView.isHidden = true
        self.activityIndicatorView.stopAnimating()
        setUpPosterImageView(poster)
        setUpNameLabel(name)
        setUpRatingStackView(starCount: starCount)
    }

    private func setUpPosterImageView(_ poster: URL?) {
        self.posterImageView.contentMode = .scaleAspectFit
        self.posterImageView.isHidden = false
        if let url = poster {
            posterImageView.setImageFillFromURL(url)
        } else {
            self.posterImageView.image = UIImage(systemName: "xmark.rectangle.fill")
        }
    }

    private func setUpNameLabel(_ name: String) {
        nameLabel.isHidden = false
        nameLabel.text = name
    }

    private func setUpRatingStackView(starCount: Int?) {
        guard let starCount = starCount else {
            ratingStackView.isHidden = true
            return
        }
        ratingStackView.isHidden = false
        ratingStackView.arrangedSubviews.enumerated().forEach { (index, view) in
            let thisStarIsMet = index < starCount
            if let starImageView = view as? UIImageView {
                starImageView.image = UIImage(systemName: thisStarIsMet ? "star.fill" : "star")
            }
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // TODO: Still figuring out WHY the frame needs to be
        // adjusted at `draw`, and why `layoutSubvies` is not
        // sufficient.
        // The adjustment NEEDS to be made in both calls.
        posterOverlayView.layer.sublayers?.first?.frame = posterImageView.bounds
    }

    private func addAnOverlayToTheImageView() {
        guard !posterImageView.isHidden else { return }

        posterOverlayView.layer.sublayers?.first?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.name = "GradientOverlay"
        gradient.frame = posterImageView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0, 1]

        self.posterOverlayView.layer.insertSublayer(gradient, at: 0)
        posterOverlayView.layer.masksToBounds = true

    }

}
