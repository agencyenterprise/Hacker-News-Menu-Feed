import Foundation
import SwiftUI

struct CustomLink: View {
    @Environment(\.dismiss) var dismiss
    
    var title: String
    var link: String
    
    var body: some View {
        Link(destination: URL(string: link)!, label: {
            Text(title).underline()
        })
        .underline()
        .foregroundColor(.white)
        .onHover(perform: { hovering in
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop()
            }
        })
        .environment(\.openURL, OpenURLAction { url in
            dismiss()
            return .systemAction
        })
    }
}
