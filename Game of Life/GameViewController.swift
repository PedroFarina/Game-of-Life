//
//  GameViewController.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 31/10/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {

    private var scene: SCNScene = {
        guard let scene = SCNScene(named: "art.scnassets/GameScene.scn") else {
            fatalError("Não foi possível inicializar a cena")
        }
        return scene
    }()
    private lazy var sceneView: SCNView = {
        guard let view = self.view as? SCNView else {
            fatalError("Não foi possível inicializar a view")
        }
        view.delegate = self
        view.scene = scene
        view.allowsCameraControl = true
        view.showsStatistics = false
        return view
    }()
    
    private lazy var gridController: LifeGridController = LifeGridController(scene: scene, sceneView: sceneView, tileDimension: SCNVector3(1, 1, 1))

    var cameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        return cameraNode
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 1000, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        // create and add a camera to the scene
        scene.rootNode.addChildNode(cameraNode)
        for i in -3...3 {
            gridController.addAt(LifeNodePool.getLife(), coordinate: SCNVector3(i, 0, 0))
        }

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 50, z: 0)
        cameraNode.eulerAngles = SCNVector3(-89.5, 0, 0)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    func makeNewGeneration() {
        gridController.nextGeneration()
    }

    func makeGlider() {
        for i in 0...2 {
            let life = LifeNodePool.getLife()
            gridController.addAt(life, coordinate: SCNVector3(0, 0, -i))
        }
        gridController.addAt(LifeNodePool.getLife(), position: SCNVector3(1,0,0))
        gridController.addAt(LifeNodePool.getLife(), position: SCNVector3(2,0,-1))
    }

    var timeToLoop = 0.8
    var currentTime = 0.8
    var enabled = false
    var generation = 0
    var offset = SCNVector3(0, -1, 0)
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if enabled {
            if time > currentTime {
                if generation == 12 {
                    makeChristmas()
                } else {
                    generation += 1
                    gridController.nextGeneration(moveBy: offset)
                }
                currentTime = time + timeToLoop
            }
        }
    }

    var piscaPiscaNodes: [SCNNode] = []
    var piscapiscaColors: [UIColor] = [#colorLiteral(red: 0.8697137237, green: 0.3656387925, blue: 0.8691763282, alpha: 1), #colorLiteral(red: 0.7858144641, green: 0.8306753039, blue: 0.06237793714, alpha: 1), #colorLiteral(red: 0, green: 0.4612190127, blue: 0.8387741446, alpha: 1)]
    func makeChristmas() {
        if piscaPiscaNodes.isEmpty {
            timeToLoop = 1
            if let star = scene.rootNode.childNode(withName: "star", recursively: true) {
                star.isHidden = false
            }
            for node in scene.rootNode.childNodes {
                node.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 0, green: 0.5852099061, blue: 0, alpha: 1)
                if node.position.y != 0 {
                    if node.position.y > -12 {
                        let rand = Int.random(in: 0...100)
                        if rand % 6 == 0 {
                            piscaPiscaNodes.append(node)
                            if let material = node.geometry?.firstMaterial {
                                material.diffuse.intensity = 0.7
                                makePiscaPiscaAnimation(property: material.emission)
                            }
                        } else if rand % 5 == 0 {
                            node.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.7882512212, green: 0.09814932197, blue: 0.1365611553, alpha: 1)
                        }
                    } else {
                        node.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.4106108546, green: 0.2178105116, blue: 0.04584360868, alpha: 1)
                    }
                }
                
            }
        }
        
        for piscapisca in piscaPiscaNodes {
            if let material = piscapisca.geometry?.firstMaterial {
                var color = piscapiscaColors.randomElement()
                while color == material.diffuse.contents as? UIColor {
                    color = piscapiscaColors.randomElement()
                }
                material.diffuse.contents = color
                material.emission.contents = color
            }
        }
    }
    
    func makePiscaPiscaAnimation(property: SCNMaterialProperty) {
        let animation = CABasicAnimation(keyPath: "intensity")
        animation.fromValue = 0.0
        animation.toValue = 0.8
        animation.duration = timeToLoop/2
        animation.autoreverses = true
        animation.repeatCount = .infinity
        
        property.addAnimation(animation, forKey: "extrude")
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        enabled = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
