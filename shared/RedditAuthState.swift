//
//  RedditAuthState.swift
//  redditweaks
//  5.0
//  10.16
//
//  Created by bermudalocket on 6/29/20.
//  Copyright © 2020 bermudalocket. All rights reserved.
//

import Combine

class RedditAuthState: ObservableObject {
    public static let shared = RedditAuthState()
    private init() { }

    @Published var accessToken: Reddit.AccessToken = .empty
}
