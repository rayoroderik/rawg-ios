//
//  FavouriteListViewController.swift
//  rawg-ios
//
//  Created by Rayo on 12/03/23.
//

import UIKit

class FavouriteListViewController: UIViewController {
    // View
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 136)
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var errorView: UIView = UIView()
    var errorLabel: UILabel = UILabel()
    
    // View Model
    let viewModel: FavouriteListViewModel = FavouriteListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupErrorView()
        setupConstraint()
        setupCallback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        viewModel.getGameList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        guard let tabBar = tabBarController?.view else { return }
        UIView.transition(with: tabBar, duration: 0.35, options: .transitionCrossDissolve, animations: nil)
    }
    
    func setupView() {
        navigationItem.title = "Favourite Game"
        view.backgroundColor = .systemBackground
        
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: "GameCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl // iOS 10+
    }
    
    func setupErrorView() {
        view.addSubview(errorView)
        errorView.addSubview(errorLabel)
        errorView.backgroundColor = .systemBackground
        errorView.isHidden = true
        errorLabel.font = .systemFont(ofSize: 16, weight: .medium)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        
        setupErrorConstraint()
    }
    
    func setupConstraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupErrorConstraint() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupCallback() {
        viewModel.didGetData = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }

        viewModel.updateErrorView = { [weak self] in
            guard let self = self else { return }
            let isHidden = self.viewModel.getErrorMessage().isEmpty
            self.toggleErrorView(isHidden: isHidden)
        }
    }
    
    @objc private func didPullToRefresh(_ sender: Any) {
        viewModel.getGameList()
    }
    
    func toggleErrorView(isHidden: Bool) {
        errorView.isHidden = isHidden
        errorLabel.text = viewModel.getErrorMessage()
    }
}

extension FavouriteListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell else {
            return UICollectionViewCell()
        }
        
        guard let games = viewModel.getGames() else { return cell }
        
        let game = games[indexPath.row]
        cell.populate(image: game.imageURL, name: game.name,
                      releaseDate: game.releaseDate, rating: game.rating)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let games = viewModel.getGames() else { return }
        let game = games[indexPath.row]

        let viewController = GameDetailViewController()
        viewController.setGameID(id: Int(game.gameID))
        navigationController?.pushViewController(viewController, animated: true)
    }
}
