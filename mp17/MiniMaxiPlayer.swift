//
//  MiniMaxiPlayer.swift
//  mp17
//
//  Created by Andrew Us on 21.11.23.
//

import SwiftUI

struct MiniMaxiPlayer: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let song: Song?
    let playerOffset: CGFloat
        
    @State private var dragOffset = CGSize.zero
    @State private var isExpanded: Bool = false
    
    var closeLine: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill()
            .frame(width: 56, height: 6)
    }

    var songCover: some View {
        Group {
            // для размера и расположения songImage в расширеном плеере
            let width = UIScreen.main.bounds.size.width
            
            ZStack {
                if let song {
                    song.songImage
                        .resizable()
                        .scaledToFit()
                } else {
                    RoundedRectangle(cornerRadius:
                        isExpanded ? 15 : 4)
                        .fill(.gray)
                    Image(systemName: "music.note")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(isExpanded ? 48 : 8)
                }
            }
            .frame(width: isExpanded ? width / 1.3 : 40,
                   height: isExpanded ? width / 1.3 : 40)
            .shadow(radius: isExpanded ? 10 : 0)
        }
    }
    
    var songTitle: some View {
        HStack {
            Text(song?.songTitle ?? "Not playing")
                .bold()
            
            if isExpanded {
                Spacer()
                
                Button {} label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(Color.fadeGray, .white)
                }
            }
        }
        .font(isExpanded ? .title : .title3)
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
    
    var playButtons: some View {
        HStack(spacing: isExpanded ? 0 : 24) {
            if isExpanded {
                Spacer()
                
                Button {} label: {
                    Image(systemName: "backward.fill")
                }
            }
            
            Spacer()
            
            Button {} label: {
                Image(systemName: "play.fill")
            }
            .font(.system(size: isExpanded ? 72 : 24))
            
            if isExpanded { Spacer() }
            
            Button {} label: {
                Image(systemName: "forward.fill")
            }
            
            if isExpanded { Spacer() }
        }
        .font(.system(size: isExpanded ? 48 : 24))
        .foregroundStyle(isExpanded ? Color.fadeGray : .gray)
    }
    
    var body: some View {
        let layout = isExpanded ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        layout {
            if isExpanded {
                closeLine
                    .padding(safeAreaInsets.top)
                
                Spacer()
            }
            
            songCover
                    
            if isExpanded {
                Spacer()
            }
            
            songTitle
                
            if isExpanded {
                timeLine
                    .padding(.vertical)
            }
                        
            playButtons
                .padding(.horizontal)
                .animation(.spring(response: 1.5, dampingFraction: 0.4), value: isExpanded)
                
            if isExpanded {
                volumeBar
                    .padding(.vertical)
                    
                bottomButtons
                    .padding(.bottom)
                    .frame(alignment: .bottom)
            }
        }
        .padding(isExpanded ? 16 : 8)
        .frame(maxWidth: .infinity,
               maxHeight: isExpanded ? .infinity : nil) // 56
        .background(isExpanded ? Color.gray : Color.white)
        .foregroundColor(isExpanded ? Color.lightGray : Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 0 : 12))
        .padding(.horizontal, isExpanded ? 0 : 4)
        .shadow(radius: isExpanded ? 0 : 12)

        .animation(.interpolatingSpring(mass: 1.5, stiffness: 100, damping: 20), value: isExpanded)
        
        .offset(y: isExpanded ? dragOffset.height : -playerOffset)
        .onTapGesture { if !isExpanded { isExpanded.toggle() } }
        .gesture(DragGesture()
            .onChanged { gesture in
                dragOffset = gesture.translation
            }
            .onEnded { _ in
                if abs(dragOffset.height) > 120 {
                    isExpanded.toggle()
                    dragOffset = .zero
                } else {
                    dragOffset = .zero
                }
            }
        )
    }
}

#Preview {
    ContentView()
}
