//
//  CharactersViewModel.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 08/12/22.
//

import Foundation

/// ViewModel for Character Module
final class CharactersViewModel {

    var characters: [Character] = [] // Array of characters
    private var nextPageUrl: String? = Constants.API.characterURL // API URL
    private var isFetchingRecords = false // Check whether records are fetch or not
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding using closure - Manage Event of loading
    typealias CharacterResult = (CharacterResponseModel, DataError) -> Void
    private lazy var previousRun = Date.now // Debounce Compare data
    private let minInterval = 0.05 // Delay

    /// Fetch characters with Pagination
    func checkForNextPage(index: Int) {
        guard !isFetchingRecords && index == characters.count - 1 else {
            return
        }
        fetchCharacters()
    }

    // Fetch Characters from API
    func fetchCharacters() {
        guard let nextPageUrl = self.nextPageUrl else {
            return
        }
        self.eventHandler?(.loading) // Loading State
        self.isFetchingRecords = true
        
        Task { @MainActor in
            let result = await self.fetchCharacterResponse(nextPageUrl)
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

    // Fetch Characters with the help of Handler
    private func fetchCharacterResponse(_ url: String) async -> Result<CharacterResponseModel, DataError> {
        return await NetworkHandler.shared.get(url: url)
    }

    // Filter characters by name
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

}

// MARK: - Event handler
extension CharactersViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ message: String)
    }
}
