import Foundation
import SwiftUI

struct AppMenu: View {
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    
    @Binding var posts: [StoryFetchResponse]
    @Binding var isFetching: Bool
    @Binding var showOnlyIcon: Bool
    
    var onRefreshTapped: () -> Void
    
    func quitAction() {
        NSApplication.shared.terminate(nil)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if isFetching {
                Text("Refreshing feed data...").padding()
            } else {
                PostsListing(posts: posts)
                Actions(onRefresh: onRefreshTapped, onQuit: quitAction, showOnlyIcon: $showOnlyIcon)
                Divider()
                Footer()
            }
            
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
        
    }
}
