import Foundation
import SwiftUI

struct PostsListing: View {
    @Environment(\.dismiss) var dismiss
    
    var posts: [StoryFetchResponse]
    
    var body: some View {
        ForEach(Array(posts.enumerated()), id: \.element.id) { index, post in
            VStack(alignment: .leading) {
                
                HStack {
                    Image(.triangle)
                        .resizable()
                        .frame(width: 13, height: 13)
                    
                    CustomLink(title: post.title!, link: "https://news.ycombinator.com/item?id=\(post.id)")
                }
                
                if post.url != nil {
                    CustomLink(title: "post external link", link: post.url!)
                        .padding(.leading, 22)
                        .padding(.bottom, 5)
                        .font(.system(size: 11.5))
                }
                
                HStack {
                    
                    Text("\(post.score) points by")
                        .font(.system(size: 12))
                        .padding(.leading, 17.5)
                    
                    CustomLink(title: post.by, link: "https://news.ycombinator.com/user?id=\(post.by)")
                    
                    Text("\(post.comments ?? 0) comments")
                        .font(.system(size: 12))
                }
            }
            .padding(.leading, 10)
            .padding(.top, index == 0 ? 5 : 0)
            
            Divider()
        }
    }
}
