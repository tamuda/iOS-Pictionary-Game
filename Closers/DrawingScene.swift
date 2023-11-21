//
//  DrawingScene.swift
//  Closers
//
//  Created by Chen, Yanshi on 11/15/23.
//

import Foundation
import SpriteKit

class DrawingScene: SKScene {
    private var confirmButton: SKSpriteNode!
    private var currentLine: SKShapeNode?
    private var path: CGMutablePath?
    private var lineSegments: [SKShapeNode] = []
    private var background: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        // Play sound effect
        run(SKAction.playSoundFileNamed("draw.mp3", waitForCompletion: false))

        physicsWorld.gravity = CGVector(dx:0, dy:-9.8)
        
//        print(frame.midX, frame.midY, frame.maxX, frame.maxY, frame.minX, frame.minY)
        
//        Previous Prompt
        let prompt = SKLabelNode()
        prompt.text = "Prompt: " + (Data.shared.prompts.last ?? "")
        prompt.fontSize = 24
        prompt.fontColor = .black
        prompt.fontName = "SFPro-Bold"
        prompt.position = CGPoint(x:frame.minX+150, y:frame.maxY-150)
        addChild(prompt)
        
        
        // Floor
        let floor = SKSpriteNode(color:.clear, size: CGSize(width: frame.width, height: 10))
        floor.position = CGPoint(x:frame.midX, y:150)
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.isDynamic = false
        floor.name = "floor"
        addChild(floor)
        
        // Border
        let border_left = SKSpriteNode(color:.clear, size: CGSize(width: 10, height: frame.height))
        border_left.position = CGPoint(x:130, y:frame.midY)
        border_left.physicsBody = SKPhysicsBody(rectangleOf: border_left.size)
        border_left.physicsBody?.isDynamic = false
        border_left.name = "border_left"
        addChild(border_left)
        
        let border_right = SKSpriteNode(color:.clear, size: CGSize(width: 10, height: frame.height))
        border_right.position = CGPoint(x:1200, y:frame.midY)
        border_right.physicsBody = SKPhysicsBody(rectangleOf: border_right.size)
        border_right.physicsBody?.isDynamic = false
        border_right.name = "border_right"
        addChild(border_right)
        
        // Confirm Button
        confirmButton = SKSpriteNode(color: UIColor(red:0, green:0, blue:0, alpha:1), size:CGSize(width:200, height:50))
        confirmButton.position = CGPoint(x: frame.maxX-170, y:frame.minY+150)
        confirmButton.name = "confirmButton"
        addChild(confirmButton)
        
        let buttonText = SKLabelNode(text: "Next")
        buttonText.position = CGPoint(x:0, y:-10)
        buttonText.fontColor = SKColor.white
        buttonText.fontName = "SFPro-Bold"
        confirmButton.addChild(buttonText)

    }
    
    private func setupBackground() {
            background = SKSpriteNode(imageNamed: "backgroundImage-02")
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
        let location = touch.location(in: self)
        
        if confirmButton.contains(location){
            // Play sound effect
            run(SKAction.playSoundFileNamed("next.mp3", waitForCompletion: false))
            run(SKAction.playSoundFileNamed("wow.mp3", waitForCompletion: false))
            Data.shared.drawings.append(lineSegments)
            Data.shared.rounds += 1
            
            if Data.shared.rounds < Data.shared.numPlayers {
                let nextScene = DescriptionScene(size: self.size)
                nextScene.scaleMode = self.scaleMode
                self.view?.presentScene(nextScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name("End"), object:nil)
                
            }
        }
        
        startDrawing(at:location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        continueDrawing(at: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishDrawing()
    }
    
    private func startDrawing(at position: CGPoint){
        path = CGMutablePath()
        path?.move(to:position)
        
        currentLine = SKShapeNode()
        currentLine?.strokeColor = SKColor.black
        currentLine?.lineWidth = 5
        currentLine?.path = path
        
        if let currentLine = currentLine {
            addChild(currentLine)
        }
    }
    
    private func continueDrawing(at position: CGPoint) {
        path?.addLine(to: position)
        currentLine?.path = path
    }
    
    private func finishDrawing(){
        if let path = path, let currentLine=currentLine{
            let physicsBody = SKPhysicsBody(polygonFrom: path)
            currentLine.physicsBody = physicsBody
            currentLine.physicsBody?.restitution = 0
            lineSegments.append(currentLine)
        }
        currentLine = nil
        path = nil
    }

    
}
