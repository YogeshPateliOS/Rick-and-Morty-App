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
    
    fileprivate var character: Character?
    
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
    
    func getAllCharacters(){
        charactersViewModel.getAllCharacters { character in
            self.createSnapshot(characters: character.results)
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
