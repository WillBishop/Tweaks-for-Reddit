//
// Created by bermudalocket on 1/25/20.
// Copyright (c) 2020 bermudalocket. All rights reserved.
//

import Combine
import Foundation

struct Feature: Hashable {

    /**
     User defaults key.
     */
    let key: String

    /**
     Description shown in popover.
     */
    let description: String

    let javascript: String

    let javascriptOff: String?

    init(name: String, description: String, javascript: String, javascriptOff: String? = nil) {
        self.key = name
        self.description = description
        self.javascript = javascript
        self.javascriptOff = javascriptOff
    }

}

extension Feature: Comparable {
    static func < (lhs: Feature, rhs: Feature) -> Bool {
        lhs.description < rhs.description
    }
}

extension Feature {

    static var mainSectionFeatures: [Feature] = {
        features
            .filter { $0 != .customSubredditBar }
            .sorted { a, b in
                a.description < b.description
            }
    }()

    static let features: [Feature] = [
        Feature.noChat,
        Feature.showKarma,
        Feature.customSubredditBar,
        Feature.hideAds,
        Feature.removePromotedPosts,
        Feature.hideUsername,
        Feature.collapseChildComments,
        Feature.collapseAutoModerator,
        Feature.hideNewRedditButton,
        Feature.hideRedditPremiumBanner,
        Feature.nsfwFilter,
        Feature.noHappeningNowBanners,
        Feature.oldRedditRedirect,
    ]

    static func fromDescription(_ description: String) -> Feature? {
        features.first(where: { $0.description == description })
    }

    static let oldRedditRedirect = Feature(name: "oldReddit", description: "Always use old.reddit.com", javascript: """
        if (window.location.href.startsWith("https://www.reddit")) {
            window.location = window.location.href.replace("www", "old")
        }
    """)

    static let noHappeningNowBanners = Feature(name: "noHappeningNowBanners", description: "Remove Happening Now banners", javascript: """
        $('.happening-now-wrap').hide();
    """, javascriptOff: """
        $('.happening-now-wrap').show();
    """)

    static let noChat = Feature(name: "noChat", description: "Remove chat", javascript: """
        watchForChildren(document.body, "script", (ele) => {
            const script = ele;
            if ((/^\\/_chat/).test(new URL(script.src, location.origin).pathname)) {
                script.remove();
            }
        });

        watchForChildren(document.body, '#chat-app', ele => {
            ele.remove();
        });
    """, javascriptOff: """
    """)

    static let showKarma = Feature(name: "showKarma", description: "Show karma", javascript: """
        let username = $('.user a').text();
        let url = (window.location.href.startsWith("https://old")) ? `https://old.reddit.com/user/${username}` : `https://www.reddit.com/user/${username}`;
        let karmaArea = $('span .userkarma');
        let karma = karmaArea.text();
        karmaArea.html(`<a href='${url}/submitted/'>${karma}</a>`);

        let userHTML = $.get(url, function(data) {
            let ck = $(data).find('.comment-karma').text();
            let cmturl = `<a href='${url}/comments/'>${ck}</a>`;
            $('span .userkarma').append(" | " + cmturl);
        });
    """)

    static let customSubredditBar = Feature(
        name: "customSubredditBar",
        description: "Custom subreddit bar",
        javascript: """
            let span = `<span class='separator'>-</span>`;
            let subs = [%SUBS%];
            $('#sr-header-area ul').last().children().each(function(i) {
                if (i >= subs.length) {
                    $(this).hide();
                    return;
                }
                let sub = subs[i];
                let html = `<a class='choice' href='https://www.reddit.com/r/${sub}'>${sub}</a>`;
                if (i < subs.length - 1) {
                    html = `${html}${span}`
                }
                $(this).html(html);
                let remove = $('<div style="display: inline-block" title="Remove ' + sub + ' from favorites">&nbsp;[-]</div>')
                remove.click(function() { safari.extension.dispatchMessage("redditweaks.removeFavoriteSub", { "subreddit": sub }); location.reload(); })
                $(this).hover(function() { if (i < subs.length - 1) { $(this).children().last().before(remove) } else { $(this).append(remove) } }, function() { remove.remove() });
            });
        """)
    /*
            let disable = [%DISABLEDSHORTCUTS%];
            $('#sr-header-area ul').first().children().each(function(i) {
                if (disable.includes(i + 1)) {
                    $(this).hide();
                }
            });
        """)
*/
    
    static let hideAds = Feature(
        name: "hideAds",
        description: "Hide ads",
        javascript: """
            $('.ad-container, .ad-container, #ad_1').each(function() {
                $(this).remove();
            });
        """,
        javascriptOff: """
            $('.ad-container, .ad-container ').each(function() {
                $(this).show();
            });
        """
    )

    static let removePromotedPosts = Feature(
        name: "removePromotedPosts",
        description: "Hide promoted posts",
        javascript: """
            $('.promoted').each(function() {
                $(this).hide();
            });
        """,
        javascriptOff: """
            $('.promoted').each(function() {
                $(this).show();
            });
        """
    )

    static let hideUsername = Feature(
        name: "hideUsername",
        description: "Remove username from user bar",
        javascript: """
            $('#header-bottom-right .user a').first().hide();
        """,
        javascriptOff: """
            $('#header-bottom-right .user a').first().show();
        """
    )

    static let collapseAutoModerator = Feature(
        name: "collapseAutoModerator",
        description: "Collapse AutoModerator",
        javascript: """
            $('div[data-author=AutoModerator]').each(function() {
                $(this).removeClass('noncollapsed');
                $(this).addClass('collapsed');
                $(this).find('.expand').html('[+]');
            });
        """,
        javascriptOff: """
            $('div[data-author=AutoModerator]').each(function() {
                $(this).removeClass('collapsed');
                $(this).addClass('noncollapsed');
                $(this).find('.expand').html('[-]');
            });
        """
    )

    static let collapseChildComments = Feature(
            name: "collapseChildComments",
            description: "Collapse replies to top-level comments",
            javascript: """
                        $('.comment .noncollapsed').each(function() {
                            $(this).removeClass('noncollapsed');
                            $(this).addClass('collapsed');
                            $(this).find('.expand').html('[+]');
                        });
                        """,
            javascriptOff: """
                        $('.comment .collapsed').each(function() {
                            $(this).removeClass('collapsed');
                            $(this).addClass('noncollapsed');
                            $(this).find('.expand').html('[-]');
                        });
                        """)

    static let hideRedditPremiumBanner = Feature(
        name: "hideRedditPremiumBanner",
        description: "Hide Reddit Premium banner",
        javascript: "$('.premium-banner-outer').hide();",
        javascriptOff: "$('.premium-banner-outer').show();")

    static let hideNewRedditButton = Feature(
        name: "hideNewRedditButton",
        description: "Hide New Reddit button",
        javascript: "$('.redesign-beta-optin').hide();",
        javascriptOff: "$('.redesign-beta-optin').show();")

    static let nsfwFilter = Feature(
        name: "nsfwFilter",
        description: "Filter NSFW posts",
        javascript: """
                    $('.over18').each(function() {
                        $(this).hide();
                        safari.extension.dispatchMessage("redditweaks.incrementCounter");
                    })
                    """,
        javascriptOff: """
                    $('.over18').each(function() {
                        $(this).show();
                        safari.extension.dispatchMessage("redditweaks.decrementCounter");
                    })
                    """)

}
