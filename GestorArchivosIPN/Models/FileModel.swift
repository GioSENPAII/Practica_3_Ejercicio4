//
//  FileModel.swift
//  GestorArchivosIPN
//
//  Created by Giovanni Javier Longoria Bunoust on 17/04/25.
//

import Foundation
import SwiftUI

struct FileModel: Identifiable {
    let id = UUID()
    let name: String
    let path: URL
    let size: Int64
    let dateCreated: Date
    let dateModified: Date
    let fileType: FileType
    var isFavorite: Bool = false
    
    var icon: Image {
        switch fileType {
        case .folder:
            return Image(systemName: "folder")
        case .image:
            return Image(systemName: "photo")
        case .document:
            return Image(systemName: "doc")
        case .pdf:
            return Image(systemName: "doc.text")
        case .audio:
            return Image(systemName: "music.note")
        case .video:
            return Image(systemName: "film")
        case .other:
            return Image(systemName: "doc")
        }
    }
    
    var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    var formattedDateModified: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateModified)
    }
}

enum FileType: String, CaseIterable {
    case folder = "folder"
    case image = "image"
    case document = "document"
    case pdf = "pdf"
    case audio = "audio"
    case video = "video"
    case other = "other"
    
    static func getType(from url: URL) -> FileType {
        let extension = url.pathExtension.lowercased()
        
        switch extension {
        case "jpg", "jpeg", "png", "gif", "heic", "heif", "webp":
            return .image
        case "pdf":
            return .pdf
        case "doc", "docx", "txt", "rtf", "pages":
            return .document
        case "mp3", "wav", "aac", "m4a":
            return .audio
        case "mp4", "mov", "avi", "m4v":
            return .video
        default:
            if url.hasDirectoryPath {
                return .folder
            }
            return .other
        }
    }
}
