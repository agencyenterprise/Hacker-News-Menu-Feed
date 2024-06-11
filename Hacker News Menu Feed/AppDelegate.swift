import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    public var statusItem: NSStatusItem!
    public var menu = NSMenu()
    public var currentUrl = "";
    public var currentId = 0;

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "Loading Hacker News Feed!"
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.load), userInfo: nil, repeats: true)

        let one = NSMenuItem(title: "Open in Browser", action: #selector(self.openInBrowser), keyEquivalent: "o")
        
        self.menu.addItem(one)

        self.menu.addItem(NSMenuItem.separator())

        self.menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        self.statusItem.menu = self.menu
        
        load()
    }
    
    @objc public func load() {
        statusItem.button?.title = "Loading Hacker News Feed..."
        
        getStories { stories in
            
            for (idx, story) in stories.enumerated() {
                let dispatchAfter = DispatchTimeInterval.seconds(idx * 120)

                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
                    let storyTitle = story.title.count <= 35 ? story.title : story.title.prefix(35) + "..."
                    
                    self.statusItem.button?.title = storyTitle
                    self.currentUrl = story.url ?? ""
                    self.currentId = story.id
                    
                }
            }
        }
    }
    
    @objc func openInBrowser() {
        let url = URL(string: "https://news.ycombinator.com/item?id=\(currentId)")!
        NSWorkspace.shared.open(url)
    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    struct Story: Decodable {
        let id: Int
        let title: String
        let url: String?
    }
    
    
    func getStories(_ completion: @escaping(_ stories : [Story]) -> ()) {
        

        let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json")!


        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                var stories = [Story]()
                let indexes = (try decoder.decode([Int].self, from: data)).prefix(20)
                
                for index in indexes {
                   let storyUrl = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(index).json")!
                    
                    URLSession.shared.dataTask(with: storyUrl) { data, _, _ in
                        
                        defer {
                            if index == indexes.last {
                                completion(stories)
                            }
                        }

                        guard let data = data else { return }
                        
                        do {
                            let story = (try decoder.decode(Story.self, from: data))
                            stories.append(story)
                        } catch {
                            print(error)
                        }
                    }.resume()
                }
            } catch {
                print(error)
                completion([])
            }
        }.resume()
        
    }


}
