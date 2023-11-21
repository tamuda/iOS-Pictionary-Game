//
//  DescriptionScene.swift
//  Closers
//
//  Created by Chen, Yanshi on 11/15/23.
//

import Foundation
import SpriteKit

class DescriptionScene: SKScene {
    private var prompt: UITextField!
    private var confirmButton: SKSpriteNode!
    private var background: SKSpriteNode!
    
    
    override func didMove(to view:SKView) {
        self.physicsWorld.gravity = CGVector(dx:0, dy:0)
        setupBackground()
        displayPreviousDrawing()
//        print(frame.midX, frame.midY, frame.maxX, frame.maxY, frame.minX, frame.minY)
         
        prompt = UITextField(frame: CGRect(x:200, y:50, width:300, height:40))
        prompt.borderStyle = .roundedRect
        prompt.placeholder = "Describe the drawing"
        
        self.view?.addSubview(prompt)
        
        // Confirm Button
        confirmButton = SKSpriteNode(color: UIColor(red:0, green:0, blue:0, alpha:1), size:CGSize(width:200, height:50))
        confirmButton.position = CGPoint(x: frame.maxX-150, y:frame.minY+150)
        confirmButton.name = "confirmButton"
        addChild(confirmButton)
        
        let buttonText = SKLabelNode(text: "Confirm")
        buttonText.position = CGPoint(x:0, y:-10)
        buttonText.fontColor = SKColor.white
        confirmButton.addChild(buttonText)
        
    }
    
    private func displayPreviousDrawing(){
        guard let lastDrawing = Data.shared.drawings.last else {return}
        for line in lastDrawing {
            addChild(line.copy() as! SKShapeNode)
        }
    }
    
    private func setupBackground() {
            background = SKSpriteNode(imageNamed: "backgroundImage-04")
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.zPosition = -1 // Ensures it's behind other nodes
        let widthRatio = self.size.width / background.size.width
            let heightRatio = self.size.height / background.size.height
            let scaleRatio = min(widthRatio, heightRatio)
        background.setScale(scaleRatio)
            addChild(background)
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in:self)
        if confirmButton.contains(location){
            // Play sound effect
            run(SKAction.playSoundFileNamed("next.mp3", waitForCompletion: false))
            prompt.resignFirstResponder()
            prompt.removeFromSuperview()
            
            
            if let promptText = prompt.text {
                Data.shared.prompts.append(promptText)
                Data.shared.rounds += 1
                
                if Data.shared.rounds < Data.shared.numPlayers {
                    let nextScene = DrawingScene(size: self.size)
                    nextScene.scaleMode = self.scaleMode
                    self.view?.presentScene(nextScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name("End"), object:nil)
                }
            }
            else {
                print("did not enter prompt")
            }
        }
    }
    
    
}
