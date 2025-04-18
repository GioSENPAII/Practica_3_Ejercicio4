//
//  GestorArchivosWidgetsLiveActivity.swift
//  GestorArchivosWidgets
//
//  Created by Giovanni Javier Longoria Bunoust on 17/04/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GestorArchivosWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GestorArchivosWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GestorArchivosWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GestorArchivosWidgetsAttributes {
    fileprivate static var preview: GestorArchivosWidgetsAttributes {
        GestorArchivosWidgetsAttributes(name: "World")
    }
}

extension GestorArchivosWidgetsAttributes.ContentState {
    fileprivate static var smiley: GestorArchivosWidgetsAttributes.ContentState {
        GestorArchivosWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GestorArchivosWidgetsAttributes.ContentState {
         GestorArchivosWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GestorArchivosWidgetsAttributes.preview) {
   GestorArchivosWidgetsLiveActivity()
} contentStates: {
    GestorArchivosWidgetsAttributes.ContentState.smiley
    GestorArchivosWidgetsAttributes.ContentState.starEyes
}
