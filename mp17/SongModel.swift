//
//  SongModel.swift
//  mp17
//
//  Created by Andrew Us on 21.11.23.
//

import SwiftUI

struct Song {
    let songTitle: String
    let songAuthor: String
    let songImage: Image // String
    let songLenght: Double
    let isDolbyAtmos: Bool
}

struct MockData {
    static let NirvanaNevermind: Song = .init(songTitle: "Nevermind",
                                              songAuthor: "Nirvana",
                                              songImage: Image(.nirvanaCover),
                                              songLenght: 342,
                                              isDolbyAtmos: true)
}
