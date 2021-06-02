//
//  ContentView.swift
//  land in sight
//
//  Created by Samuel Brasileiro on 26/05/21.
//

import SwiftUI
import SpriteKit

struct GameView: View{
    @ObservedObject public var sceneLoader = GameSceneLoader()
    var body: some View{
        SpriteView(scene: sceneLoader.scene)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
    }
    
}
struct StartGameView: View {
    @State var isPresentingGame: Bool = false
    var body: some View {
        NavigationView{
            VStack{
                Text("Land in Sight!")
                    .bold()
                    .padding(.bottom, 200)
                
                NavigationLink(
                    destination: GameView(),
                    isActive: $isPresentingGame){ Text("Press any key to start")}
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView()
    }
}
