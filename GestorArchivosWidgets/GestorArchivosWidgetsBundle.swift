//
//  GestorArchivosWidgetsBundle.swift
//  GestorArchivosWidgets
//
//  Created by Giovanni Javier Longoria Bunoust on 17/04/25.
//

import WidgetKit
import SwiftUI

@main
struct GestorArchivosWidgetsBundle: WidgetBundle {
    var body: some Widget {
        GestorArchivosWidgets()
        GestorArchivosWidgetsControl()
        GestorArchivosWidgetsLiveActivity()
    }
}
