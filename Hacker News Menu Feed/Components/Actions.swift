import Foundation
import SwiftUI

struct Actions: View {
    var onRefresh: () -> Void
    var onQuit: () -> Void
    
    @Binding var showOnlyIcon: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .frame(width: 5)
                
                Text("The data is refreshed automatically every 60 seconds")
                    .font(.system(size: 12.5))
                    .foregroundColor(.white)
            }
            .foregroundColor(.gray)
            .padding(.leading, 12)
            .padding(.vertical, 1)
            
            HStack {
                Button(action: onRefresh, label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .frame(width: 5)
                            .foregroundColor(.white)
                        
                        Text("Refresh data")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                })
                .padding(.leading, 16)
                
                Button(action: onQuit, label: {
                    Text("Quit").foregroundColor(.white)
                })
            }
            
            Toggle("Show only an icon on the menu bar", isOn: $showOnlyIcon)
                .toggleStyle(SwitchToggleStyle())
                .padding(.leading, 16)
        }
        .padding(.bottom, 5)
    }
}
