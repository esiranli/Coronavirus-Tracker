//
//  NewsView.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 9.04.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI
import FeedKit

struct NewsView: View {
    
    @State
    private var showSafari = false
    
    @ObservedObject
    private var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.feedItems) { (item: FeedItem) in
                NavigationLink(destination: SafariView(url: URL(string: item.link!)!)) {
                    NewsRow(item: item)
                }
            }.navigationBarTitle(Text("News"))
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}

class NewsViewModel: ObservableObject {
    
    @Published var feedItems = [FeedItem]()
    
    init() {
        loadNews()
    }
    
    func loadNews() {
        let feedURL = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/Health.xml")!
        let parser = FeedParser(URL: feedURL)
        // Parse asynchronously, not to block the UI.
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            switch (result) {
            case .success(let feed):
                if let items = feed.rssFeed?.items {
                    DispatchQueue.main.async {
                        self.feedItems = items.map({ FeedItem(title: $0.title, description: $0.description, link: $0.link, media: $0.media?.mediaContents?.first?.attributes?.url) })
                        print(self.feedItems)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

struct NewsRow: View {
    let item: FeedItem
    
    var body: some View {
        HStack {
            ImageViewContainer(imageURL: item.media ?? "").frame(width: 50, height: 50)
            Text(item.title ?? "N/A")
        }
    }
    
}

struct FeedItem: Identifiable, Decodable {
    let id = UUID()
    var title: String?
    var description: String?
    var link: String?
    var media: String?
    
//    init(title: String?) {
//        self.title = title
//        self.description = nil
//        self.link = nil
//        self.media = nil
//    }
}
