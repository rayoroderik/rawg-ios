//
//  GameInformationView.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import UIKit

class GameInformationView: UIView {
    
    var publisherLabel: UILabel = UILabel()
    var gameTitleLabel: UILabel = UILabel()
    var releaseDateLabel: UILabel = UILabel()
    var ratingIcon: UIImageView = UIImageView()
    var ratingLabel: UILabel = UILabel()
    var playerIcon: UIImageView = UIImageView()
    var playerLabel: UILabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        commonInit()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupView()
    }
    
    func commonInit() {
        addSubview(publisherLabel)
        addSubview(gameTitleLabel)
        addSubview(releaseDateLabel)
        addSubview(ratingIcon)
        addSubview(ratingLabel)
        addSubview(playerIcon)
        addSubview(playerLabel)

        setupConstraints()
    }
    
    func setupView() {
        
        publisherLabel.font = .systemFont(ofSize: 14, weight: .light)
        publisherLabel.numberOfLines = 1
        
        gameTitleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        gameTitleLabel.numberOfLines = 1
        
        releaseDateLabel.font = .systemFont(ofSize: 14, weight: .light)
        releaseDateLabel.numberOfLines = 1
        
        ratingLabel.font = .systemFont(ofSize: 14, weight: .light)
        ratingLabel.numberOfLines = 1
        
        playerLabel.font = .systemFont(ofSize: 14, weight: .light)
        playerLabel.numberOfLines = 1
        
        layoutIfNeeded()
    }
    
    func setupConstraints() {
        publisherLabel.translatesAutoresizingMaskIntoConstraints = false
        gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingIcon.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        playerIcon.translatesAutoresizingMaskIntoConstraints = false
        playerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            publisherLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            publisherLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            publisherLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            gameTitleLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 8),
            gameTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            gameTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            releaseDateLabel.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            ratingIcon.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            ratingIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            ratingIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingIcon.trailingAnchor, constant: 4),
            ratingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            playerIcon.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            playerIcon.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 16),
            playerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            playerLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            playerLabel.leadingAnchor.constraint(equalTo: playerIcon.trailingAnchor, constant: 4),
            playerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    func populate(game: GameDetailModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.publisherLabel.text = game.publishers?.first?.name ?? ""
            self.gameTitleLabel.text = game.name ?? ""
            self.releaseDateLabel.text = "Release date \(game.released ?? "-")"
            self.ratingIcon.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            self.ratingLabel.text = "\(game.rating ?? 0)"
            self.playerIcon.image = UIImage(systemName: "gamecontroller")
            self.playerLabel.text = "\(game.addedByStatus?.owned ?? 0) played"
            self.layoutIfNeeded()
        }
    }
}
