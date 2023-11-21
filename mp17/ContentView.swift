//
//  ContentView.swift
//  mp17
//
//  Created by Andrew Us on 20.11.23.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded: Bool = false
    @State private var song: Song? = nil
    @Namespace var ns

    var tabBarButtons: some View {
        Button {
            withAnimation { isExpanded.toggle() }
        } label: {
            VStack {
                Image(systemName: "star.fill").font(.title)
                Text("Tab").font(.footnote).bold()
            }
        }
        .foregroundColor(.blue)
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let bottomSafeArea = geo.safeAreaInsets.bottom

            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                TabView {
                    ScrollView {
                        Group {
                            Text("line 1")
                            Text("line 2")
                        }
                        .font(.title)

                        Text("Red digital cinema komodo 6k")
                            .textCase(.uppercase)
                        HStack {
                            Text("Digital")
                            Spacer()
                        }
                    }
                    .bold()
                    .font(.system(size: 92))
                    .tabItem { Label("Tab", systemImage: "star.fill") }
                    .safeAreaInset(edge: .bottom) {
                        VStack {
                            Color.clear
                        }
                        .frame(height: 44)
                        .background(.regularMaterial)
                    }
                }

                MiniMaxiPlayer(song: song, ns: ns, isExpanded: $isExpanded)
                   .offset(y: isExpanded ? 0 : -bottomSafeArea - 48)
                    .padding(.horizontal, isExpanded ? 0 : 4)
                    .animation(
                        .interpolatingSpring(mass: 1.5, stiffness: 100, damping: 20),
                        value: isExpanded)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
