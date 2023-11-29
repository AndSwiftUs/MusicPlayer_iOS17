//
//  ContentView.swift
//  mp17
//
//  Created by Andrew Us on 20.11.23.
//

import SwiftUI

struct ContentView: View {
    let miniPlayerHeight: CGFloat = 56.0

    @State private var volume: Double = 0.3
    @State private var song: Song? = Song(songTitle: "Nevermind",
                                          songAuthor: "Nirvana",
                                          songImage: Image(.nirvanaCover),
                                          songLenght: 342,
                                          isDolbyAtmos: true)

    var body: some View {
        GeometryReader { geo in
            let screenSize = geo.size
            let screenSafeArea = geo.safeAreaInsets
            let bottomOffset = UITabBarController().height + screenSafeArea.bottom

            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                TabView {
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                        TestScrollView()
                            .background(.ultraThinMaterial)

                            .safeAreaInset(edge: .bottom) {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: bottomOffset + miniPlayerHeight)
                            }

                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: bottomOffset + miniPlayerHeight)
                            .cornerRadius(15,
                                          corners: [.topLeft, .topRight])
                    }
                    .tabItem {
                        Label("Tab", systemImage: "star.fill")
                    }
                    .toolbarBackground(.hidden, for: .tabBar)
                    .ignoresSafeArea()
                }

                MiniMaxiPlayer(song: $song,
                               volume: $volume,
                               playerOffset: bottomOffset + 8,
                               screenSize: screenSize,
                               screenSafeArea: screenSafeArea)

                    .ignoresSafeArea(.container, edges: .all)
            }
            .ignoresSafeArea()
        }
    }
}

struct TestScrollView: View {
    var body: some View {
        ScrollView {
            Group {
                Text("line 1")
                Text("line 2")
            }
            .font(.title)

            Text("Red digital cinema komodo 6k")
                .textCase(.uppercase)

            HStack {
                Text("Digital Cinema Camera")
                Spacer()
            }
        }
        .bold()
        .font(.system(size: 92))
    }
}

#Preview {
    ContentView()
}
