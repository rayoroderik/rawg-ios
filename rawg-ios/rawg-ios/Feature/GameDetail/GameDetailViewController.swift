//
//  GameDetailViewController.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    // View
    var scrollView: UIScrollView = UIScrollView()
    var contentView: UIView = UIView()
    var imageView: CustomImageView = CustomImageView()
    var gameInformationView: GameInformationView = GameInformationView()
    var descriptionLabel: UILabel = UILabel()
    
    // View Model
    let viewModel: GameDetailViewModel = GameDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        setupCallback()
        viewModel.getGameDetail()
        setFavouriteButton(isFavourite: viewModel.checkFavourite())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode =  .never
        tabBarController?.tabBar.isHidden = true
    }
    
    func setupView() {
        title = "Detail"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        contentView.addSubview(imageView)
        contentView.addSubview(gameInformationView)
        contentView.addSubview(descriptionLabel)
        scrollView.addSubview(contentView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.numberOfLines = 0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "star"), style: .plain,
                                                                 target: self, action: #selector(self.action(sender:)))
    }
    
    func setupConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gameInformationView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            gameInformationView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            gameInformationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameInformationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gameInformationView.heightAnchor.constraint(equalToConstant: 128),
            
            descriptionLabel.topAnchor.constraint(equalTo: gameInformationView.bottomAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func setupCallback() {
        viewModel.didGetData = { [weak self] in
            self?.updateView()
        }
    }
    
    func setGameID(id: Int) {
        viewModel.setGameID(id: id)
    }
    
    func updateView() {
        guard let game = viewModel.getGame(),
              let imageURL = game.backgroundImage,
              let description = game.descriptionRaw else { return }

        imageView.loadImageUsingUrlString(urlString: imageURL)

        gameInformationView.populate(game: game)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.descriptionLabel.text = description
        }
    }
    
    private func setFavouriteButton(isFavourite: Bool) {
        if isFavourite {
            let favouriteButtonBar = UIBarButtonItem
                .init(image: UIImage(systemName: "heart.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal),
                      style: .plain, target: self, action: #selector(self.action(sender:)))
            
            navigationItem.setRightBarButton(favouriteButtonBar, animated: true)
        } else {
            let favouriteButtonBar = UIBarButtonItem
                .init(image: UIImage(systemName: "heart"), style: .plain,
                      target: self, action: #selector(self.action(sender:)))
            
            navigationItem.setRightBarButton(favouriteButtonBar, animated: true)
        }
    }
    
    @objc func action(sender: UIBarButtonItem) {
        if viewModel.checkFavourite() {
            viewModel.removeFavourite()
            setFavouriteButton(isFavourite: false)
        } else {
            viewModel.saveFavourite()
            setFavouriteButton(isFavourite: true)
        }
    }
}
