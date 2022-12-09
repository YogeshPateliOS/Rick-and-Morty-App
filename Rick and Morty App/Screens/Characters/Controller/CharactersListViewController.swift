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

typealias DataSource = UICollectionViewDiffableDataSource<Section, Result>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Result>


class CharactersListViewController: UIViewController {

    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    fileprivate let charactersViewModel = CharactersViewModel()
    
    fileprivate var info: Info?
    var characters = [Result](){
        didSet{
            self.createSnapshot(characters: self.characters)
        }
    }
    private var datasource: DataSource!
    private var previousRun = Date()
    private let minInterval = 0.05
    fileprivate let searchController = UISearchController(searchResultsController: nil)

    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

}

extension CharactersListViewController{
    
    func configuration(){
        self.title = "Characters"
        characterCollectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCell")
        searchConfiguration()
        datasource = configureDataSource()
        getAllCharacters()
    }
    
    func searchConfiguration(){
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func getAllCharacters(url: String = characterURL){
        charactersViewModel.getAllCharacters(url: url) { character in
            self.info = character.info
            self.characters.append(contentsOf: character.results)
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
    
    func createSnapshot(characters: [Result]){
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(characters)
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
    }
    
}

extension CharactersListViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
    
}

extension CharactersListViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController else{
            return
        }
        detailVC.character = characters[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 &&             searchController.searchBar.text?.isEmpty == true{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let info = self.info,
                      let next = info.next else { return }
                self.getAllCharacters(url: next)
            }
        }
    }
    
}

extension CharactersListViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            characters.removeAll()
            if searchText.isEmpty{
                getAllCharacters()
            }else{
                getAllCharacters(url: "\(filterCharacterURL)\(searchText)")
            }
        }
    }
    
}
