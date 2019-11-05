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
import ARKit

class GameViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    private var scene: SCNScene = {
        guard let scene = SCNScene(named: "art.scnassets/GameScene.scn") else {
            fatalError("Não foi possível inicializar a cena")
        }
        return scene
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    private lazy var gridController: LifeGridController = LifeGridController(scene: scene, sceneView: sceneView, tileDimension: SCNVector3(0.1, 0.1, 0.1))

    var cameraNode: SCNNode = {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        return cameraNode
    }()

    override func viewDidLoad() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = scene
        super.viewDidLoad()

        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 100, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)

        makeGlider()
        
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
            gridController.addAt(life, coordinate: SCNVector3(-i, -10, -10))
        }
        gridController.addAt(LifeNodePool.getLife(), coordinate: SCNVector3(-1, -10,-12))
        gridController.addAt(LifeNodePool.getLife(), coordinate: SCNVector3(0, -10,-11))
    }

    let timeToLoop = 0.5
    var currentTime = 0.5
    var enabled = false
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if enabled {
            if time > currentTime {
                gridController.nextGeneration()
                currentTime = time + timeToLoop
            }
        }
    }
    
    @objc
    func handleTap(_ recognizer: UIGestureRecognizer) {
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
