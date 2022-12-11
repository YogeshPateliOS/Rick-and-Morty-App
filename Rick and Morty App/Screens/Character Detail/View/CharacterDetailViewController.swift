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
    var character: Character!
    private lazy var viewModel = CharacterDetailsViewModel(character: character)

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

    @IBAction func loadMoreEpisodes(_ sender: UIButton) {
        self.viewModel.loadMoreEpisodes()
    }
}

extension CharacterDetailViewController {

    private func configuration() {
        guard character != nil else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Idetifier.cell)
        detailConfiguration()
        viewModel.loadMoreEpisodes()
        viewModel.dataSourceUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func detailConfiguration() {
        title = viewModel.character.name
        thumbnailImageView.layer.cornerRadius = 12
        statusValueLabel.text = viewModel.character.status
        specieValueLabel.text = viewModel.character.species
        genderValueLabel.text = viewModel.character.gender
        locationValueLabel.text = viewModel.character.location.name
        statusImageView.tintColor = viewModel.character.status == Constants.alive ? .green : .red
        thumbnailImageView.loadImageAsync(with: viewModel.character.image)
    }

}

extension CharacterDetailViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard character != nil else { return 0 }
        return viewModel.episodes.count == viewModel.episodesUrl.count ? 3 : 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return viewModel.episodes.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            guard var cell = tableView.dequeueReusableCell(withIdentifier: Constants.Idetifier.cell) else {
                return UITableViewCell()
            }
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.Idetifier.cell)
            cell.selectionStyle = .none
            var content = cell.defaultContentConfiguration()
            let info = self.viewModel.episodes[indexPath.row]
            content.text = info.episode + " - " + info.name
            content.secondaryText = info.airDate
            cell.contentConfiguration = content
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "\(Constants.episodes) (\(viewModel.episodesUrl.count))"
        }
        return super.tableView(tableView, titleForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return UITableView.automaticDimension
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
