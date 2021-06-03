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
        //env.turn = .mission
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
                        Text("É a vez do pirata \(env.currentPlayer + 1)!")
                            .font(.custom("Eight Bit Dragon", size: 80))
                            .foregroundColor(.black)
                            .padding()
                        
                            Text("arraste para cima para jogar o dado")
                                .font(.custom("Connection II", size: 40))
                                .foregroundColor(.black)
                                
                        Button(action:{
                            env.turn = .throwingDice
                            
                            
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
            else if(env.turn == .acceptingDice){
                Image("dado\(env.dice)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
            }
            else if env.turn == .mission{
                
                    Image("map")
                        .resizable()
                        .scaledToFit()
                        .padding(100)
                        .overlay(
                            VStack{
                                Text(env.currentMission.text)
                                    .font(.custom("Eight Bit Dragon", size: 60))
                                    .foregroundColor(.black)
                                    .padding()
                                
                                    Text(env.currentMission.action)
                                        .font(.custom("Connection II", size: 60))
                                        .foregroundColor(.black)
                                        
                                Button(action:{
                                    env.turn = .consequence
                                    
                                    
                                }){
                                }.opacity(0.1)
                            }
                            .padding(200)
                        )
                    
                    
                
            }
        }
        
    }
    
}
struct StartGameView: View {
    @State var isPresentingGame: Bool = false
    var body: some View {
        NavigationView{
            VStack{
                Text("Terra à vista!")
                    .bold()
                    .padding(.bottom, 200)
                
                NavigationLink(
                    destination: GameView(),
                    isActive: $isPresentingGame){ Text("Aperte pra começar")}
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
