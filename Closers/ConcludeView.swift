//
//  ConcludeView.swift
//  Closers
//
//  Created by Chen, Yanshi on 11/15/23.
//

import SwiftUI
import SpriteKit


struct ShapeNodeView: UIViewRepresentable {
    var nodes: [SKShapeNode]
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        
        view.showsFPS = false
        view.showsNodeCount = false
        let scene = SKScene(size: CGSize(width:1330, height:700))
        scene.backgroundColor = .white
        scene.physicsWorld.gravity = CGVector(dx:0, dy:0)
        

        for line in nodes {
            scene.addChild(line.copy() as! SKShapeNode)
        }
        
        view.presentScene(scene)
        return view
    }
    func updateUIView(_ uiView: SKView, context: Context) {

        if let scene = uiView.scene {
            scene.removeAllChildren()
            for line in nodes {
                scene.addChild(line.copy() as! SKShapeNode)
            }
        }
    }
}

struct ConcludeView: View {
    let allPrompts = Data.shared.prompts
    let allDrawings = Data.shared.drawings
    
    let testNode = SKShapeNode(circleOfRadius: 50)
    
    
    var body: some View {
        ScrollView {
            Text("History")
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees:8))
                .fontWeight(.heavy)
                .font(.system(size:48))
                .shadow(color: .gray, radius:3, x:0, y:0)
                .padding()
            
            let maxCount = max(allPrompts.count, allDrawings.count)
            ForEach(0..<maxCount, id: \.self) { index in
                VStack {
                    if index < allPrompts.count {
                        Text("Description: " + allPrompts[index])
                            .padding()
                    }
                    
                    if index < allDrawings.count {
                        ShapeNodeView(nodes: allDrawings[index])
                            .frame(width:1330, height:700)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .border(Color.black, width:3)
                            .padding()
                    }

                }
                
            }
        }
        .padding()
    }
}

struct ConcludeView_Previews: PreviewProvider {
    static var previews: some View {
        ConcludeView()
    }
}
