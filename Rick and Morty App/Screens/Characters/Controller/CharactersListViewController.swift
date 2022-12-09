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
    var characters = [Result]()
    private var datasource: DataSource!
    
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
        characterCollectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCell")
        datasource = configureDataSource()
        getAllCharacters()
    }
    
    func getAllCharacters(url: String = characterURL){
        charactersViewModel.getAllCharacters(url: url) { character in
            self.info = character.info
            self.characters.append(contentsOf: character.results)
            self.createSnapshot(characters: self.characters)
        }
    }
    
}

extension CharactersListViewController{
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Result> {
        
        let dataSource = DataSource(collectionView: characterCollectionView) { (collectionView, indexPath, character) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
            cell.character = character
            
            return cell
        }
        
        return dataSource
    }
    
    func createSnapshot(characters: [Result]){
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        datasource.apply(snapshot, animatingDifferences: true)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let info = self.info,
                      let next = info.next else { return }
                self.getAllCharacters(url: next)
            }
        }
    }
    
}
