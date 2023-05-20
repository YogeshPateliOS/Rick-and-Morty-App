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
    private let handler = NetworkHandler()

    // DI - Dependency Injection
    init(character: Character) {
        self.character = character
        self.episodesUrl = character.episode
    }


    /// Fetch Episode Details
    /// - Parameters:
    ///   - url: pass episode URL
    ///   - completion: Passing Episode Details

   @MainActor func getEpisodeDetail(
        url: String
   ) async -> EpisodeDetail? {
       do {
           let episodeDetail: EpisodeDetail = try await handler.request(url: url)
           return episodeDetail
       }catch {
           print(error)
           return nil
       }
   }

    // Load More Episode - Loading 20 Episode at a time
    func loadMoreEpisodes() {
        guard !episodesUrl.isEmpty,
              episodesUrl.count > episodes.count else {
            return
        }
        // min(0 + 20, 0 + (51 - 0) -> 20 records
        let endIndex = min((episodes.count + pageSize), episodes.count + (episodesUrl.count - episodes.count))
        let urlsToLoad = Array(episodesUrl[episodes.count..<endIndex])
        Task {
            await loadCharacters(urls: urlsToLoad)
        }
    }

    // Loading episode details with Dispatch Group - Memory Handling and once all episode details are loaded then only will update the UI.
    @MainActor func loadCharacters(urls: [String]) async {
        var episodeArray: [EpisodeDetail] = []

        for url in urls {
            guard let episode = await self.getEpisodeDetail(url: url) else { return }
            episodeArray.append(episode)
        }

        self.episodes += episodeArray
        self.dataSourceUpdated?()
    }

}
