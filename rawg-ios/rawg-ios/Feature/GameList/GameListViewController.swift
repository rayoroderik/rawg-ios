//
//  GameListViewController.swift
//  rawg-ios
//
//  Created by Rayo on 11/03/23.
//

import Foundation
import UIKit

class GameListViewController: UIViewController {
    // View
    var searchBar: UISearchBar = UISearchBar()
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
    let viewModel: GameListViewModel = GameListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupErrorView()
        setupConstraint()
        setupCallback()
        viewModel.getGameList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        guard let tabBar = tabBarController?.view else { return }
        UIView.transition(with: tabBar, duration: 0.35, options: .transitionCrossDissolve, animations: nil)
    }
    
    func setupView() {
        navigationItem.title = "Games For You"
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.backgroundImage = UIImage()
        
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: "GameCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(searchBar)
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
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
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
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupCallback() {
        viewModel.didGetData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }

        viewModel.updateErrorView = { [weak self] in
            guard let self = self else { return }
            let isHidden = self.viewModel.getErrorMessage().isEmpty
            self.toggleErrorView(isHidden: isHidden)
        }
    }
    
    @objc private func didPullToRefresh(_ sender: Any) {
        if viewModel.checkIsSearching() {
            refreshControl.endRefreshing()
        } else {
            viewModel.refresh()
        }
    }
    
    func toggleErrorView(isHidden: Bool) {
        DispatchQueue.main.async {
            self.errorView.isHidden = isHidden
            self.errorLabel.text = self.viewModel.getErrorMessage()
        }
    }
}

extension GameListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell else {
            return UICollectionViewCell()
        }
        
        guard let games = viewModel.getGames(), !games.isEmpty else { return cell }
        
        let game = games[indexPath.row]
        cell.populate(image: game.backgroundImage, name: game.name,
                      releaseDate: game.released, rating: game.rating)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let games = viewModel.getGames() else { return }
        let game = games[indexPath.row]
        guard let gameID = game.id else { return }

        let viewController = GameDetailViewController()
        viewController.setGameID(id: gameID)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getListCount() - 8 {
            viewModel.loadNextPage()
        }
    }
}

extension GameListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchGame(keyword: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            viewModel.searchGame(keyword: searchText)
        } else {
            viewModel.endSearch()
            viewModel.refresh()
        }
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.endSearch()
        viewModel.refresh()
        searchBar.endEditing(true)
    }
}

extension GameListViewController: TabBarReselectHandling {
    func handleReselect() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
