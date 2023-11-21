//
//  GameScene.swift
//  Closers
//
//  Created by Chen, Yanshi on 11/15/23.
//

import SpriteKit
import GameplayKit




class GameScene: SKScene {
    private var numPlayers: UITextField!
    private var confirmButton: SKSpriteNode!
    private var background: SKSpriteNode!

    
    override func didMove(to view: SKView) {
       
        setupBackground()
        setupConfirmButton()
        numPlayers = UITextField(frame: CGRect(x:280, y:150, width:300, height:40))
        numPlayers.borderStyle = .roundedRect
        numPlayers.placeholder = "Enter the Number of Players"
        numPlayers.keyboardType = .numberPad
        
        self.view?.addSubview(numPlayers)
        
        
    }
    private func setupConfirmButton() {
        confirmButton = SKSpriteNode(color: UIColor(red: 0, green: 0.8, blue: 0.4, alpha: 1), size: CGSize(width: 250, height: 100))
        confirmButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        confirmButton.name = "confirmButton"
        confirmButton.zPosition = 1 // Ensures it's above the background
        addChild(confirmButton)
        
        let buttonText = SKLabelNode(text: "Start")
        buttonText.position = CGPoint(x: 0, y: -10)
        buttonText.fontColor = SKColor.black
        buttonText.fontName = "SFPro-Bold"
        buttonText.zPosition = 2 // Ensures the label is above the button
        confirmButton.addChild(buttonText)
        
        // Adding a texture to the button for a better look
        confirmButton.texture = SKTexture(imageNamed: "buttonTexture")
    }
    
    private func setupBackground() {
        background = SKSpriteNode(imageNamed: "backgroundImage-01")
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
            run(SKAction.playSoundFileNamed("next2.mp3", waitForCompletion: false))
            numPlayers.resignFirstResponder()
            numPlayers.removeFromSuperview()
            
            if let number = Int(numPlayers.text ?? ""), number > 1{
                Data.shared.numPlayers = number
                
                let nextScene = PromptScene(size: self.size)
                nextScene.scaleMode = self.scaleMode
                self.view?.presentScene(nextScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            } else {
                print("Not Enough Player")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
}

