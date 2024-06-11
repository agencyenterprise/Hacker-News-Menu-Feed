import Foundation
import SwiftUI

struct Footer: View {
    
    let githubLink = "https://github.com/agencyenterprise/hacker-news-menu-feed"
    
    let aeWebsiteLink = "https://ae.studio/?utm_source=sds&utm_medium=referral&utm_campaign=sds-hacker-news-menu-feed&utm_content=macOSfooter&utm_term=3ff5251a-e107-4d47-bfb8-b2962debd252"
    
    var body: some View {
        HStack {
            Text("Made with 🧡 by")
            CustomLink(title: "AE Studio", link: aeWebsiteLink)
            Text("•").padding(.horizontal, 5)
            CustomLink(title: "github repository", link: githubLink)
        }
        .padding(.leading, 10)
        .padding(.vertical, 2)
        .padding(.bottom, 3)
    }
}
