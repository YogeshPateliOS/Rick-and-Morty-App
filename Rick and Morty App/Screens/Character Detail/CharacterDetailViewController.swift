//
//  CharacterDetailViewController.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import UIKit

class CharacterDetailViewController: UITableViewController {

    @IBOutlet weak var genderValueLabel: UILabel!
    @IBOutlet weak var specieValueLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var statusValueLabel: UILabel!
    var info: Info?
    var character: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

}

extension CharacterDetailViewController{
    
    func configuration(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = character?.name
        thumbnailImageView.layer.cornerRadius = 12
        statusValueLabel.text = character?.status
        specieValueLabel.text = character?.species
        genderValueLabel.text = character?.gender
        locationValueLabel.text = character?.location.name
        statusImageView.tintColor = character?.status == "Alive" ? .green : .red
        thumbnailImageView.loadImageAsync(with: character?.image)
        
    }
    
}

extension CharacterDetailViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return character?.episode.count ?? 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            CharactersViewModel().getEpisodeDetail(
                url: character?.episode[indexPath.row] ?? "") { episode in
                    DispatchQueue.main.async {
                        var content = cell?.defaultContentConfiguration()
                        content?.text = episode.episode + "-" + episode.name
                        content?.secondaryText = episode.airDate
                        cell?.contentConfiguration = content
                    }
                }
            return cell!
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2{
            return "EPISODES (\(character?.episode.count ?? 0))"
        }
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            return UITableView.automaticDimension
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
}
