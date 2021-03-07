//
//  AppState.swift
//  redditweaks
//
//  Created by Michael Rippe on 2/25/21.
//  Copyright © 2021 bermudalocket. All rights reserved.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {

    // MARK: - task storage

    private var cancellables = [URLSessionDataTask]()

    // MARK: - saved GUI state

    @AppStorage("isSettingsExpanded") var isSettingsExpanded = false
    @AppStorage("isFeaturesListExpanded") var isFeaturesListExpanded = true
    @AppStorage("verifySubreddits") var doSubredditVerification = true

    // MARK: - features

    @Published var features = [Feature: Bool]()
    @AppStorage("favoriteSubreddits") var favoriteSubreddits = FavoriteSubreddits()

    init() {
        Feature.features.forEach { feature in
            self.features[feature] = Redditweaks.defaults.bool(forKey: feature.key)
        }
    }

    final func bindingForFeature(_ feature: Feature) -> Binding<Bool> {
        .init(get: {
            self.features[feature] ?? false
        }, set: { bool in
            var copy = [Feature: Bool]()
            self.features.forEach { copy[$0] = $1 }
            copy[feature] = bool
            Redditweaks.defaults.setValue(bool, forKey: feature.key)
            self.features = copy
        })
    }

}

extension AppState {
    func addFavoriteSubreddit(subreddit: String) {
        favoriteSubreddits.append(subreddit)
    }

    func removeFavoriteSubreddit(subreddit: String) {
        favoriteSubreddits.removeAll { $0 == subreddit }
    }

    func verifySubreddit(subreddit: String, isValid: Binding<Bool>, isSearching: Binding<Bool>) {
        if !doSubredditVerification {
            isValid.projectedValue.wrappedValue = true
            return
        }
        isSearching.projectedValue.wrappedValue = true
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let url = URL(string: "https://www.reddit.com/r/\(subreddit)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let res = response as? HTTPURLResponse,
                  res.statusCode == 200,
                  let data = data,
                  let result = String(data: data, encoding: .utf8)
            else {
                isValid.projectedValue.wrappedValue = false
                isSearching.projectedValue.wrappedValue = false
                return
            }
            let outcome = !result.contains("there doesn't seem to be anything here")
            isValid.projectedValue.wrappedValue = outcome
            isSearching.projectedValue.wrappedValue = false
        }
        cancellables.append(task)
        task.resume()
    }
}
