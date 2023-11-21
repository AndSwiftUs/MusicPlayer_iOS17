//
//  ContentView.swift
//  mp17
//
//  Created by Andrew Us on 20.11.23.
//

import SwiftUI

public extension Color {
    static var lightGray: Color { Color.white.opacity(0.6) }
    static var fadeGray: Color { Color.white.opacity(0.3) }
}

extension Double {
    func formatMmSs() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

struct Song {
    let songTitle: String
    let songImage: Image
    let songLenght: Double
}

struct ExpandedPlayer: View {
    let song: Song?
    let animation: Namespace.ID

    @Binding var isExpanded: Bool

    @ViewBuilder
    private func songImage(width: CGFloat) -> some View {
        if let song {
            song.songImage
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(.gray)
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding(width / 4)
            }
        }
    }

    var songTitle: some View {
        HStack {
            Text(song?.songTitle ?? "Not playing")

            Spacer()

            Button {} label: {
                Image(systemName: "ellipsis.circle.fill")
                    .symbolRenderingMode(.multicolor)
            }
        }
        .font(.title)
    }

    var timeLine: some View {
        VStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                .fill()
                .foregroundStyle(Color.lightGray)
                .frame(height: 10)
            HStack {
                Text("00:00")
                Spacer()
                Text(song?.songLenght.formatMmSs() ?? "00:00")
            }
        }
    }

    var playerButtons: some View {
        HStack {
            Spacer()

            Button {} label: {
                Image(systemName: "backward.fill")
            }

            Spacer()

            Button {
                isExpanded.toggle()
            } label: {
                Image(systemName: "play.fill")
            }
            .font(.system(size: 64))

            Spacer()

            Button {} label: {
                Image(systemName: "forward.fill")
            }

            Spacer()
        }
        .font(.system(size: 48))
        .foregroundStyle(Color.fadeGray)
    }

    var volumeBar: some View {
        HStack {
            Image(systemName: "volume.fill")

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill()
                    .foregroundStyle(Color.lightGray)
                    .frame(height: 10)

                RoundedRectangle(cornerRadius: 25.0)
                    .fill()
                    .foregroundStyle(Color.white)
                    .frame(width: 120, height: 10)
            }

            Image(systemName: "volume.3")
        }
        .imageScale(.large)
    }

    var bottomButtons: some View {
        HStack {
            Button {} label: {
                Image(systemName: "airplayaudio")
            }
        }
        .imageScale(.large)
        .foregroundStyle(.white)
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let imageWidth = width - (width / 3.5)
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                Color.gray

                VStack(spacing: 48) {
                    Spacer()

                    songImage(width: imageWidth)
                        .frame(width: imageWidth, height: imageWidth)
                        .shadow(radius: 20)
                        .matchedGeometryEffect(id: "cover", in: animation)

                    songTitle
                        .matchedGeometryEffect(id: "title", in: animation)

                    timeLine

                    playerButtons

                    volumeBar

                    bottomButtons
                }
                .foregroundColor(.lightGray)
                .padding()
                .padding(.bottom)
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct MiniPlayer: View {
    let song: Song?
    let animation: Namespace.ID

    @Binding var isExpanded: Bool

    var body: some View {
        HStack {
            ZStack {
                if let song {
                    song.songImage
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.gray)
                    Image(systemName: "music.note")
                        .foregroundColor(.white)
                }
            }
            .frame(width: 40, height: 40)
            .matchedGeometryEffect(id: "cover", in: animation)

            Text(song?.songTitle ?? "Not playing")
                .font(.title3)
                .bold()
                .matchedGeometryEffect(id: "title", in: animation)

            Spacer()

            HStack(spacing: 24) {
                Button {} label: {
                    Image(systemName: "arrowtriangle.forward.fill")
                }

                Button {} label: {
                    Image(systemName: "forward.fill")
                }
            }
            .imageScale(.large)
            .padding(.horizontal)
        }
        .foregroundColor(.gray)
        .padding(8)
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}

struct ContentView: View {
    @State private var isExpanded: Bool = false
    @State private var song: Song? = nil
    @Namespace var animation

    @ViewBuilder
    private func tabBarButtons() -> some View {
        Group {
            Image(systemName: "star.fill")
                .font(.title)
            Text("Tab")
                .font(.footnote)
                .bold()
        }
        .foregroundColor(isExpanded ? .red : .blue)
    }

    @ViewBuilder
    private func tabBar() -> some View {
        VStack {
            if !isExpanded {
                MiniPlayer(song: song, animation: animation, isExpanded: $isExpanded)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 4)
                    .shadow(radius: 12)
                    .offset(y: -8)
                    .matchedGeometryEffect(id: "player", in: animation)

                tabBarButtons()

            } else {
                ExpandedPlayer(song: song, animation: animation, isExpanded: $isExpanded)
                    .matchedGeometryEffect(id: "palyer", in: animation)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThickMaterial)
        .animation(.easeInOut(duration: 1), value: isExpanded)
        .transition(.identity)
    }

    var body: some View {
        ZStack {
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
        }
        .safeAreaInset(edge: .bottom) {
            tabBar()
        }
    }
}

#Preview {
    ContentView()
}
