//
//  CharacterDetailsViewModel.swift
//  Rick and Morty App
//
//  Created by Yogesh Patel on 10/12/22.
//

import Foundation

class CharacterDetailsViewModel {
    let character: Character
    var episodesUrl: [String] = []
    var episodes: [EpisodeDetail] = []
    var dataSourceUpdated: (() -> Void)?

    init(character: Character) {
        self.character = character
        self.episodesUrl = character.episode
    }

    func loadMoreEpisodes() {
        guard !episodesUrl.isEmpty,
              episodesUrl.count > episodes.count else {
            return
        }
        let endIndex = min((episodes.count + 20), episodes.count + (episodesUrl.count - episodes.count))
        let urlsToLoad = Array(episodesUrl[episodes.count..<endIndex])
        loadCharacters(urls: urlsToLoad)

    }

    func loadCharacters(urls: [String]) {
        var episodeArray: [EpisodeDetail] = []
        let group = DispatchGroup()
        for url in urls {
            group.enter()
            CharactersViewModel().getEpisodeDetail(
                url: url) { episode in
                    episodeArray.append(episode)
                    group.leave()
                }
        }

        group.notify(queue: .main) {
            self.episodes += episodeArray
            self.dataSourceUpdated?()
        }
    }

}
