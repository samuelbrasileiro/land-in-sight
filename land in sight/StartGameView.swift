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
                    Image("turn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1200, height: 1000)
                        .offset(y: -30)
                    VStack{
                        Text("Player \(env.currentPlayer + 1)'s turn!")
                            .font(.custom("Eight Bit Dragon", size: 90))
                            .foregroundColor(.black)
                            .padding()
                        
                            Text("swipe up to roll the dice")
                                .font(.custom("Connection II", size: 60))
                                .foregroundColor(.black)
                                
                        Button(action:{
                            env.setDice()
                            env.turn = .throwingDice
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                                env.turn = .walking
                            }
                        }){
                        }.opacity(0.1)
                        
                    }
                }
                
            }
            else if(env.turn == .throwingDice){
                Image("dado\(env.dice)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
            }
            
            else if env.turn == .mission{
                
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
