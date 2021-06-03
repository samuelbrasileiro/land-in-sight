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

    @ObservedObject var env = GameEnvironment()
    public init(){
        sceneLoader = GameSceneLoader(environment: env)
        
    }
    var body: some View{
        ZStack{
            SpriteView(scene: sceneLoader.scene)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            if(env.turn == .waitingToDice){
                ZStack{
                    
                    VStack{
                        Text("Player \(env.currentPlayer + 1)'s turn!")
                            .font(.custom("Eight Bit Dragon", size: 90))
                            .foregroundColor(.black)
                            .padding()
                        Text("Swipe up to roll the dice")
                            .font(.custom("Connection II", size: 60))
                            .foregroundColor(.black)
                            .padding(.bottom)
                    }
                }
                
            }
        }
        
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
        GameView()
    }
}
