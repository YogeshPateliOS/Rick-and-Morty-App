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

    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    private lazy var viewModel = CharactersViewModel()
    
    private var datasource: DataSource!
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)

    let createLayout: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  NSCollectionLayoutSize(
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

extension CharactersListViewController{
    
    func configuration(){
        self.title = "Characters"
        characterCollectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCell")
        searchConfiguration()
        datasource = configureDataSource()
        observeEvents()
        viewModel.fetchCharacters()
    }
    
    func searchConfiguration(){
        searchController.searchBar.placeholder = "Search"
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
                break
            case .stopLoading:
                break
            case .dataLoaded:
                self.createSnapshot(characters: self.viewModel.characters)
            case .error(let message):
                /// Alert show kri daish
                print(message)
            }
        }
    }
    
}

extension CharactersListViewController{
    
    func configureDataSource() -> DataSource {
        
        let dataSource = DataSource(collectionView: characterCollectionView) { (collectionView, indexPath, character) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
            cell.character = character
            
            return cell
        }
        
        return dataSource
    }
    
    func createSnapshot(characters: [Character]){
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(characters)
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
    }
    
}

extension CharactersListViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController else{
            return
        }
        detailVC.character = viewModel.characters[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.checkForNextPage(index: indexPath.row)
        }
    }
    
}

extension CharactersListViewController: UISearchResultsUpdating{
    
    /// Debounce
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        self.viewModel.searchCharacters(by: searchText)
    }
    
}
