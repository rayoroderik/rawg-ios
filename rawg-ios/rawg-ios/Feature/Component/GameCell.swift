//
//  GameCell.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import UIKit

class GameCell: UICollectionViewCell {
    // View
    var gameImageView: CustomImageView = CustomImageView()
    var gameTitleLabel: UILabel = UILabel()
    var releaseDateLabel: UILabel = UILabel()
    var ratingIcon: UIImageView = UIImageView()
    var ratingLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupView()
    }

    func commonInit() {
        contentView.addSubview(gameImageView)
        contentView.addSubview(gameTitleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingIcon)
        contentView.addSubview(ratingLabel)

        setupConstraints()
    }

    func setupView() {
        gameImageView.layer.cornerRadius = 8
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.clipsToBounds = true

        gameTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        gameTitleLabel.numberOfLines = 2
        
        releaseDateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        releaseDateLabel.numberOfLines = 1
        
        ratingLabel.font = .systemFont(ofSize: 14, weight: .regular)
        ratingLabel.numberOfLines = 1

        layoutIfNeeded()
    }

    func setupConstraints() {
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingIcon.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            gameImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            gameImageView.heightAnchor.constraint(equalToConstant: 120),
            gameImageView.widthAnchor.constraint(equalToConstant: 160),
            
            gameTitleLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            gameTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            gameTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            releaseDateLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            releaseDateLabel.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ratingIcon.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 16),
            ratingIcon.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            ratingIcon.widthAnchor.constraint(equalToConstant: 16),
            ratingIcon.heightAnchor.constraint(equalToConstant: 16),
            
            ratingLabel.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 2),
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func populate(image: String?, name: String?, releaseDate: String?, rating: Double?) {
        
        gameImageView.image = nil
        
        if let imageURL = image {
            gameImageView.loadImageUsingUrlString(urlString: imageURL)
        }
       
        gameTitleLabel.text = name
        releaseDateLabel.text = "Release date \(releaseDate ?? "-")"
        ratingIcon.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        ratingLabel.text = "\(rating ?? 0)"
    }
}
