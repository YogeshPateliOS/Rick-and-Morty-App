//
//  CharacterDetailViewController.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import UIKit

class CharacterDetailViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var genderValueLabel: UILabel!
    @IBOutlet weak var specieValueLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var loadMoreButton: UIButton!

    // MARK: - Variables
    var character: Character!
    private lazy var viewModel = CharacterDetailsViewModel(character: character)
    private var sectionTitles: [String] = []

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

    @IBAction func loadMoreEpisodes(_ sender: UIButton) {
        self.viewModel.loadMoreEpisodes()
    }
}

// MARK: - Helper Methods
extension CharacterDetailViewController {

    // UI Configuration
    private func configuration() {
        guard character != nil else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifier.cell)
        detailConfiguration()
        localiseUI()
        viewModel.loadMoreEpisodes()
        viewModel.dataSourceUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // Character Detail Configuration
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

    private func localiseUI(){
        statusLabel.text = Constants.Localizable.status
        specieLabel.text = Constants.Localizable.specie
        genderLabel.text = Constants.Localizable.gender
        locationLabel.text = Constants.Localizable.location
        loadMoreButton.setTitle(Constants.Localizable.loadMore, for: .normal)
        sectionTitles = [
            Constants.Localizable.appearance,
            Constants.Localizable.info
        ]
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate Methods
extension CharacterDetailViewController {

    // Combination of Static and Dynamic Row
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
            guard var cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.cell) else {
                return UITableViewCell()
            }
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.Identifier.cell)
            var content = cell.episodeListContentConfiguration()
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
            return "\(Constants.Localizable.episodes) (\(viewModel.episodesUrl.count))"
        }
        if section == 0 || section == 1{
            return sectionTitles[section]
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
