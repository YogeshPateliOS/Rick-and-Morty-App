//
//  CharactersViewModel.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

final class CharactersViewModel {

    var characters: [Character] = []
    private var nextPageUrl: String? = Constants.API.characterURL
    private var isFetchingRecords = false
    var eventHandler: ((_ event: Event) -> Void)?
    typealias CharacterResult = (CharacterResponseModel, DataError) -> Void
    private lazy var previousRun = Date.now
    private let minInterval = 0.05

    func checkForNextPage(index: Int) {
        guard !isFetchingRecords && index == characters.count - 1 else {
            return
        }
        fetchCharacters()
    }

    func fetchCharacters() {
        guard let nextPageUrl else {
            return
        }
        eventHandler?(.loading)
        isFetchingRecords = true
        NetworkHandler.shared.get(url: nextPageUrl) { (result: Result<CharacterResponseModel, DataError>) in
            self.isFetchingRecords = false
            self.eventHandler?(.stopLoading)
            switch result {
            case .success(let model):
                self.characters.append(contentsOf: model.results)
                self.nextPageUrl = model.info.next
                self.eventHandler?(.dataLoaded)
            case .failure(let failure):
                self.eventHandler?(.error(failure.localizedDescription))
            }
        }

    }

    func searchCharacters(by name: String) {
        guard Date().timeIntervalSince(previousRun) > minInterval else {
            return
        }
        previousRun = Date()
        self.characters = []
        self.eventHandler?(.dataLoaded)
        if name.isEmpty {
            nextPageUrl = Constants.API.characterURL
        } else {
            nextPageUrl = "\(Constants.API.filterCharacterURL)\(name)"
        }
        fetchCharacters()
    }

    func getEpisodeDetail(
        url: String,
        completion: @escaping (_ episode: EpisodeDetail) -> Void
    ) {
        NetworkHandler.shared.get(
            url: url) { (result: Swift.Result<EpisodeDetail, DataError>) in
                switch result {
                case .success(let episode):
                    completion(episode)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }

}

extension CharactersViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ message: String)
    }
}
