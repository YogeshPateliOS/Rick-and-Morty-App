//
//  CharacterDetailsViewModel.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 10/12/22.
//

import Foundation

/// ViewModel for Character Details
final class CharacterDetailsViewModel {
    let character: Character // Selected Character
    var episodesUrl: [String] = [] // Episodes URLs
    var episodes: [EpisodeDetail] = [] // Array of episode details
    var dataSourceUpdated: (() -> Void)? // Data Binding Use Closure
    private let pageSize: Int = 20 // Episode Size(Limit)

    // DI - Dependency Injection
    init(character: Character) {
        self.character = character
        self.episodesUrl = character.episode
    }


    /// Fetch Episode Details
    /// - Parameters:
    ///   - url: pass episode URL
    ///   - completion: Passing Episode Details
    func getEpisodeDetail(
        url: String,
        completion: @escaping (_ episode: EpisodeDetail) -> Void
    ) {
        Task { @MainActor in
            let result = await self.fetchEpisodeDetailResponse(url)
            switch result {
            case .success(let episode):
                completion(episode)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // Fetch Episodes related to character
    private func fetchEpisodeDetailResponse(_ url: String) async -> Result<EpisodeDetail, DataError> {
        return await NetworkHandler.shared.get(url: url)
    }


    // Load More Episode - Loading 20 Episode at a time
    func loadMoreEpisodes() {
        guard !episodesUrl.isEmpty,
              episodesUrl.count > episodes.count else {
            return
        }

        let endIndex = min((episodes.count + pageSize), episodes.count + (episodesUrl.count - episodes.count))
        let urlsToLoad = Array(episodesUrl[episodes.count..<endIndex])
        loadCharacters(urls: urlsToLoad)
    }

    // Loading episode details with Dispatch Group - Memory Handling and once all episode details are loaded then only will update the UI.
    func loadCharacters(urls: [String]) {
        var episodeArray: [EpisodeDetail] = []
        let group = DispatchGroup() // Threading
        for url in urls {
            group.enter()
            self.getEpisodeDetail(
                url: url) { episode in
                    episodeArray.append(episode)
                    group.leave()
                }
        }

        // Notify once episode details are loaded.
        group.notify(queue: .main) {
            self.episodes += episodeArray
            self.dataSourceUpdated?()
        }
    }

}
