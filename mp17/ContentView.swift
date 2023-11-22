//
//  ContentView.swift
//  mp17
//
//  Created by Andrew Us on 20.11.23.
//

import SwiftUI

struct TestScrollView: View {
    var body: some View {
        ScrollView {
            Group {
                Text("line 1")
                Text("line 2")
            }
            .font(.title)
            .coordinateSpace(name: "tabbar")

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

struct ContentView: View {
    @State private var song: Song? = nil
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView {
                TestScrollView()

                    .tabItem { Label("Tab", systemImage: "star.fill") }

                    .safeAreaInset(edge: .bottom) {
                        Rectangle()
                            .fill(Material.bar)
                            .cornerRadius(25, corners: [.topLeft, .topRight])
                            .frame(height: 56) // размер мини-плеера и чуть ниже
                    }
            }

            MiniMaxiPlayer(song: song,
                           playerOffset: UITabBarController().height + safeAreaInsets.bottom + 8)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
