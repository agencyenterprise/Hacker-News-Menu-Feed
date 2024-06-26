import SwiftUI

@main
struct ContentView: App {
    private static let NUMBER_OF_POSTS = 10
    
    @State private var isFetching = false
    @State private var onlyIcon = LocalDataSource.getShowOnlyIcon()
    @State private var truncatedTitle: String = "Loading Hacker news feed..."
    @State private var posts: [StoryFetchResponse] = []
    @State private var refreshRate = 60.0
    
    var timer = Timer()
    
    var body: some Scene {
        MenuBarExtra {
            AppMenu(posts: $posts, isFetching: $isFetching, showOnlyIcon: $onlyIcon, onRefreshTapped: refreshData)
                .frame(width: 495.0)
        } label: {
            if onlyIcon {
                Image(.icon).frame(width: 5, height: 5)
                    .onAppear() {
                        startApp()
                    }
            } else {
                Text(truncatedTitle)
                    .onAppear() {
                        startApp()
                    }
            }
        }
        .menuBarExtraStyle(.window)
        .onChange(of: isFetching, perform: { _ in
            if !isFetching && posts.count > 0 {
                truncatedTitle = posts[0].title!
            }
            
            adjustTitleForMenuBar()
        })
        .onChange(of: onlyIcon, perform: { _ in
            LocalDataSource.saveShowOnlyIcon(value: onlyIcon)
        })
    }
    
    func startApp() {
        if posts.count == 0 {
            refreshData()
            Timer.scheduledTimer(withTimeInterval: refreshRate, repeats: true, block: { _ in
                refreshData()
            })
        }
    }
    
    func adjustTitleForMenuBar() {
        let maxMenuBarWidth: CGFloat = 250 // Estimate or calculate this value based on your needs
        truncatedTitle = truncateStringToFit(truncatedTitle, maxWidth: maxMenuBarWidth)
    }
    
    func truncateStringToFit(_ string: String, maxWidth: CGFloat) -> String {
        // Create a temporary label to measure the string width
        let label = NSTextField(labelWithString: string)
        label.sizeToFit()
            
        if label.frame.width <= maxWidth {
            return string
        }
            
            // Truncate the string
        var truncatedString = string
        while label.frame.width > maxWidth && truncatedString.count > 0 {
            truncatedString.removeLast()
            label.stringValue = truncatedString + "…"
            label.sizeToFit()
        }
            
        return truncatedString + "…"
    }
    
    func refreshData() {
        isFetching = true
        posts = []
        
        Task {
            do {
                try await fetchFeed()
                isFetching = false
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func fetchFeed() async throws {
        let postsIds = try await fetchTopPostsIDs()
        posts = []
        
        for postId in postsIds {
            let post = try await fetchPostById(postId: postId)
            posts.append(post)
        }
    }
    
    func fetchTopPostsIDs() async throws -> [Int] {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode([Int].self, from: data)
        
        return Array(response.prefix(ContentView.NUMBER_OF_POSTS))
    }
    
    func fetchPostById(postId: Int) async throws -> StoryFetchResponse {
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(postId).json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(StoryFetchResponse.self, from: data)
    }
}

