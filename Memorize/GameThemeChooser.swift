//
//  GameThemeChooser.swift
//  Memorize
//
//  Created by Omer on 4/21/21.
//

import SwiftUI

struct GameThemeChooser: View {
    @EnvironmentObject var store: MemoryGameStore
    
    @State var clickedTheme: MemoryGame<String>.Theme = MemoryGame<String>.Theme(name: "Default", color: UIColor.RGB(red: 0, green: 0, blue: 1, alpha: 1), emojis: ["⏱","⏰","🕰"], numberOfPairs: 3)
    @State var editMode: EditMode = .inactive
    @State var showThemeEditor: Bool = false
    @State var showThemeAdder: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes!) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))) {
                        HStack{
                            Group {
                                if editMode == .active {
                                    Image(systemName: "pencil").imageScale(.large)
                                        .onTapGesture {
                                            clickedTheme = theme
                                            showThemeEditor = true
                                        }
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("\(theme.name)").foregroundColor(Color(theme.color))
                                HStack {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(theme.emojis, id: \.self) { emoji in
                                                Text(emoji)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.themes![$0] }.forEach { theme in
                        store.removeTheme(theme)
                    }
                }
            }
            .sheet(isPresented: $showThemeEditor) {
                ThemeEditor(showThemeEditor: $showThemeEditor, theme: $clickedTheme).environmentObject(self.store)
            }
            .navigationBarTitle(Text("Choose your theme!"))
            .navigationBarItems(leading: ThemeAdder().environmentObject(self.store),
                                trailing: EditButton()).zIndex(1)
            .environment(\.editMode, $editMode)
        }
        .onAppear() {
            BckgMusicPlayer.shared.startBckgMusic(name: "Bckg Music", type: "mp3")
        }
    }
}



struct ThemeAdder: View {
    @EnvironmentObject var store: MemoryGameStore
    
    var body: some View {
        HStack {
            Button(action: {
                store.addTheme()
                playSoundEffect(name: "New Theme")
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            })
            Button(action: {
                store.loadBasicThemes()
                playSoundEffect(name: "LoadBasicThemes")
            }, label: {
                Image(systemName: "plus.square.fill.on.square.fill").imageScale(.large)
            })
        }
    }
}


struct ThemeEditor: View {
    @EnvironmentObject var store: MemoryGameStore
    @Binding var showThemeEditor: Bool
    @Binding var theme: MemoryGame<String>.Theme
    
    @State private var tempThemeName: String = ""
    @State private var tempNumberOfPairs: Int = 0
    @State private var emojisToAdd: String = ""
    @State private var emojisToDelete: String = ""
    @State private var selectedColor: ColorSquare = blankColor
    
    var body: some View {
        VStack {
            ZStack{
                Text("Theme Editor")
                HStack{
                    Button(action: {
                        reset()
                        showThemeEditor = false
                        })
                    { Text("Cancel") }
                    Spacer()
                    Button(action: {
                        if let index = store.themes?.firstIndex(matching: theme) {
                            store.themes![index].name = tempThemeName
                            
                            for char1 in emojisToAdd {
                                store.themes![index].emojis.append(String(char1))
                            }
                            for char2 in emojisToDelete {
                                if let index2 = store.themes![index].emojis.firstIndex(of: String(char2)) {
                                    store.themes![index].emojis.remove(at: index2)
                                }
                            }
                            store.themes![index].color = selectedColor.color
                            store.themes![index].numberOfPairs = store.themes![index].emojis.count
                            reset()
                        }
                        showThemeEditor = false
                    }) {Text("Done")}
                }
            }
            .padding()
            Form {
                TextField("Theme Name", text: $tempThemeName)
                TextField("Add Emojis", text: $emojisToAdd)
                Section(header: Text("Remove Emojis")) {
                    Grid(theme.emojis.map { String($0) }, id: \.self) { emoji in
                        Text(emoji).font(.system(size: 40))
                            .onTapGesture {
                                emojisToDelete = emojisToDelete + (emoji)
                            }
                    }
                    .frame(height: CGFloat((theme.emojis.count - 1) / 6) * 70 + 70)
                    TextField("Click on an emoji to add it to your delete list", text: $emojisToDelete)
                }
                Section(header: Text("Number of Pairs")) {
                    Stepper("\(tempNumberOfPairs)", onIncrement: { tempNumberOfPairs += 1 } , onDecrement: { tempNumberOfPairs -= 1 } )
                }
                Section(header: Text("Choose Color")) {
                    Grid(colorSquares) { color in
                        ZStack {
                            Rectangle().foregroundColor(Color(color.color))
                            Rectangle()
                                .stroke(lineWidth: selectedColor.color == color.color ? 5 : 3)
                                .foregroundColor(selectedColor.color == color.color ? Color.blue : Color.black)
                        }
                        .onTapGesture {
                            selectedColor = color
                        }
                        .padding(5)
                    }
                    .frame(height: CGFloat((colorSquares.count - 1) / 6) * 70 + 70)
                }
            }
        }
        .onAppear { tempThemeName = theme.name ; selectedColor.color = theme.color ; tempNumberOfPairs = theme.numberOfPairs }
    }
    
    private func reset() {
        emojisToAdd = ""
        emojisToDelete = ""
    }
}

// MARK: - Theme related
private let blankColor: ColorSquare = ColorSquare(name: "", color: UIColor.RGB(red: 0, green: 0, blue: 0, alpha: 0))
private var colorSquares: [ColorSquare] =
    [
        ColorSquare(name: "Blue", color: UIColor.RGB(red: 0, green: 0, blue: 1, alpha: 1)),
        ColorSquare(name: "Yellow", color: UIColor.RGB(red: 0.9, green: 0.9, blue: 0.1, alpha: 1)),
        ColorSquare(name: "Red", color: UIColor.RGB(red: 1, green: 0, blue: 0, alpha: 1)),
        ColorSquare(name: "Grey", color: UIColor.RGB(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)),
        ColorSquare(name: "Green", color: UIColor.RGB(red: 0, green: 1, blue: 0, alpha: 1)),
        ColorSquare(name: "Orange", color: UIColor.RGB(red: 1, green: 0.54901960784, blue: 0, alpha: 1)),
        ColorSquare(name: "Maroon", color: UIColor.RGB(red: 128/255, green: 0, blue: 0, alpha: 1)),
        ColorSquare(name: "Indigo", color: UIColor.RGB(red: 75/255, green: 0, blue: 130/255, alpha: 1)),
        ColorSquare(name: "Coral", color: UIColor.RGB(red: 240/255, green: 128/255, blue: 128/255, alpha: 1))
    ]



struct GameThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        GameThemeChooser()
    }
}
