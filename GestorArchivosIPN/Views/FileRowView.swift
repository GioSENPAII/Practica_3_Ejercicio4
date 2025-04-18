//
//  FileRowView.swift
//  GestorArchivosIPN
//
//  Created by Giovanni Javier Longoria Bunoust on 17/04/25.
//

import SwiftUI

struct FileRowView: View {
    let file: FileModel
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        HStack {
            file.icon
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(iconColor(for: file.fileType))
                .padding(.trailing, 5)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.textColor)
                
                HStack {
                    Text(file.formattedSize)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(file.formattedDateModified)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if file.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            
            if file.fileType == .folder {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(.vertical, 5)
    }
    
    private func iconColor(for fileType: FileType) -> Color {
        switch fileType {
        case .folder:
            return themeManager.currentTheme.primaryColor
        case .image:
            return .blue
        case .document:
            return .green
        case .pdf:
            return .red
        case .audio:
            return .purple
        case .video:
            return .orange
        case .other:
            return .gray
        }
    }
}
