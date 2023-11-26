//
//  MiniMaxiPlayer.swift
//  mp17
//
//  Created by Andrew Us on 21.11.23.
//

import SwiftUI

struct MiniMaxiPlayer: View {
    let song: Song?
    let playerOffset: CGFloat
    let screenSize: CGSize
    let screenSafeArea: EdgeInsets
    
    @State private var volume: Double = 0
        
    @State private var dragOffset = CGSize.zero
    @State private var isExpanded: Bool = !false
    
    var closeLine: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill()
            .frame(width: screenSize.width / 10, height: 6)
    }

    var songCover: some View {
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
        .frame(width: isExpanded ? screenSize.width / 1.5 : 40,
               height: isExpanded ? screenSize.width / 1.5 : 40)
        .shadow(radius: isExpanded ? 10 : 0)
    }
    
    var songTitle: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text(song?.songTitle ?? "Not playing")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .bold()
                    .font(isExpanded ? .title : .title3)
                    .foregroundStyle(isExpanded ? .white : .gray)

                if isExpanded {
                    if let author = song?.songAuthor {
                        Text(author)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                            .font(.title2)
                    }
                }
            }
            
            if isExpanded {
                Spacer()
                
                Button {} label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(Color.fadeGray, .white)
                        .font(.title)
                }
            }
        }
    }
    
    var timeLine: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 4)
                .fill()
                .frame(height: 8)
            HStack(spacing: 0) {
                Text("00:00")
                Spacer()
                if ((song?.isDolbyAtmos) != nil) == true { // SwiftFormat %-(
                    Group {
                        Text("\(Image(systemName: "airpods.gen3"))Dolby").bold()
                            + Text(" Atmos")
                    }
                    .font(.caption)
                }
                Spacer()
                Text(song?.songLenght.formatMmSs() ?? "00:00")
            }
        }
    }
    
    var playButtons: some View {
        HStack(spacing: 0) {
            if isExpanded {
                Spacer()
                
                Button {} label: {
                    Image(systemName: "backward.fill")
                }
                
                Spacer()
            }
            
            Button {} label: {
                Image(systemName: "play.fill")
            }
            .font(isExpanded ? .largeTitle : .title2)
            .padding(.horizontal)
            
            if isExpanded { Spacer() }
            
            Button {} label: {
                Image(systemName: "forward.fill")
            }
            
            if isExpanded { Spacer() }
        }
        .font(isExpanded ? .largeTitle : .title2)
        .foregroundStyle(isExpanded ? Color.fadeGray : .gray)
    }
    
    var bottomButtons: some View {
        HStack(spacing: 0) {
            Button {} label: {
                Image(systemName: "airplayaudio")
            }
        }
        .imageScale(.large)
        .foregroundStyle(.white)
    }
    
    var body: some View {
        let layout = isExpanded ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        layout {
            if isExpanded {
                closeLine
                    .padding(screenSafeArea.top)
                
                Spacer()
            }
            
            songCover
                .animation(.spring(response: 1.5, dampingFraction: 0.8),
                           value: isExpanded)
            
            if isExpanded {
                Spacer()
            }
            
            songTitle
                .frame(maxWidth: .infinity)
            
            if isExpanded {
                timeLine
                    .padding(.vertical)
                Spacer()
            }
                        
            playButtons
                .animation(.spring(response: 1.5, dampingFraction: 0.4),
                           value: isExpanded)
                
            if isExpanded {
                Spacer()
                
                VolumeBarView(volume: $volume)
                    .padding(.vertical)

                Spacer()
                
                bottomButtons
                    .padding(.bottom)
            }
        }
        .padding(.vertical, isExpanded ? 0 : 8)
        .padding(.horizontal, isExpanded ? 24 : 8)
        .frame(maxWidth: .infinity,
               maxHeight: isExpanded ? .infinity : nil) // 56
        .background(isExpanded ? Color.gray : Color.white)
        .foregroundColor(isExpanded ? Color.lightGray : Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: isExpanded ? 0 : 12))
        .padding(.horizontal, isExpanded ? 0 : 4)
        .shadow(radius: isExpanded ? 0 : 12)

        .animation(.interpolatingSpring(mass: 1.5, stiffness: 100, damping: 20),
                   value: isExpanded)
        
        .offset(y: isExpanded ? dragOffset.height : -playerOffset)
        .onTapGesture { if !isExpanded { isExpanded.toggle() } }
        .gesture(DragGesture(minimumDistance: 10)
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
