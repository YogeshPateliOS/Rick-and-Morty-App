//
//  CharactersListViewController.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import UIKit

enum Section {
    case main
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, Character>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Character>

class CharactersListViewController: UIViewController {

    @IBOutlet weak var loadingButton: UIButton!
    @IBOutlet weak var characterCollectionView: UICollectionView!

    private lazy var viewModel = CharactersViewModel()
    private var datasource: DataSource!
    private let searchController = UISearchController(searchResultsController: nil)

    private lazy var createLayout: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(0.30)), repeatingSubitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        characterCollectionView.collectionViewLayout = createLayout
        configuration()
    }

}

extension CharactersListViewController {

    private func configuration() {
        self.title = Constants.NavTitle.characters
        characterCollectionView.register(
            UINib(nibName: CharacterCell.idetifier,
                  bundle: nil),
            forCellWithReuseIdentifier: CharacterCell.idetifier
        )
        searchConfiguration()
        datasource = configureDataSource()
        observeEvents()
        viewModel.fetchCharacters()
    }

    private func searchConfiguration() {
        searchController.searchBar.placeholder = Constants.search
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func observeEvents() {
        viewModel.eventHandler = { [weak self] event in
            guard let self else {
                return
            }
            switch event {
            case .loading:
                self.loadingButton.configurButton(title: Constants.API.loading)
            case .stopLoading:
                self.loadingButton.isHidden = true
            case .dataLoaded:
                self.createSnapshot(characters: self.viewModel.characters)
                self.loadingButton.isHidden = true
            case .error(let message):
                self.handleError(message)
            }
        }
    }

    private func handleError(_ message: String) {
        /// Filter enable and not found a name
        let name = self.searchController.searchBar.text ?? ""
        guard name.isEmpty else {
            self.loadingButton.configurButton(
                title: "\(name) name not available.",
                isShowIndicator: false
            )
            return
        }

        /// without filter error - response error or network error

        let tryAgain = UIAlertAction.tryAgainAction { [unowned self] _ in
            self.viewModel.fetchCharacters()
        }
        self.openAlert(
            title: Constants.API.errorTitle,
            message: message,
            actions: [.cancelAction, tryAgain]
        )

        self.loadingButton.isHidden = true
    }

}

extension CharactersListViewController {

    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: characterCollectionView) { collectionView, indexPath, character in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CharacterCell.idetifier,
                    for: indexPath) as? CharacterCell else {
                    return UICollectionViewCell()
                }
                cell.character = character
                return cell
            }
        return dataSource
    }

    private func createSnapshot(characters: [Character]) {
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(characters)
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
    }

}

extension CharactersListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = CharacterDetailViewController.instantiateFromStoryboard() else {
            return
        }
        detailVC.character = viewModel.characters[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.checkForNextPage(index: indexPath.row)
        }
    }

}

extension CharactersListViewController: UISearchResultsUpdating {

    /// Debounce
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        self.viewModel.searchCharacters(by: searchText)
    }

}
