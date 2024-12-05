//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 19/08/2023.
//

import Foundation

/// Represents various MIME types that can be used in HTTP requests for specifying content types.
public enum MimeType: Equatable, Hashable, Codable, Sendable {
    /// MIME type for PNG images.
    case pngImage
    /// MIME type for JPEG images.
    case jpegImage
    /// MIME type for GIF images.
    case gifImage
    /// MIME type for WebP images.
    case webpImage
    /// MIME type for SVG images.
    case svgImage
    /// MIME type for PDF documents.
    case pdfDocument
    /// MIME type for JSON data.
    case json
    /// MIME type for XML data.
    case xml
    /// MIME type for plain text data.
    case plainText
    /// MIME type for HTML documents.
    case html
    /// MIME type for CSS stylesheets.
    case css
    /// MIME type for JavaScript code.
    case javascript
    /// MIME type for MP3 audio.
    case mp3Audio
    /// MIME type for WAV audio.
    case wavAudio
    /// MIME type for OGG audio.
    case oggAudio
    /// MIME type for MP4 video.
    case mp4Video
    /// MIME type for WebM video.
    case webmVideo
    /// MIME type for AVI video.
    case aviVideo
    /// MIME type for Matroska video.
    case mkvVideo
    /// MIME type for QuickTime video.
    case movVideo
    /// Custom MIME type specified by the user.
    case some(_ mimeType: String)

    /// Returns the string value of the MIME type.
    public var stringValue: String {
        switch self {
        case .pngImage:
            "image/png"
        case .jpegImage:
            "image/jpeg"
        case .gifImage:
            "image/gif"
        case .webpImage:
            "image/webp"
        case .svgImage:
            "image/svg+xml"
        case .pdfDocument:
            "application/pdf"
        case .json:
            "application/json"
        case .xml:
            "application/xml"
        case .plainText:
            "text/plain"
        case .html:
            "text/html"
        case .css:
            "text/css"
        case .javascript:
            "application/javascript"
        case .mp3Audio:
            "audio/mpeg"
        case .wavAudio:
            "audio/wav"
        case .oggAudio:
            "audio/ogg"
        case .mp4Video:
            "video/mp4"
        case .webmVideo:
            "video/webm"
        case .aviVideo:
            "video/avi"
        case .mkvVideo:
            "video/x-matroska"
        case .movVideo:
            "video/quicktime"
        case let .some(mimeType):
            mimeType
        }
    }
}
