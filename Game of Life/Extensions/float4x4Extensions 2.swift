//
//  float4x4Extensions.swift
//  Game of Life
//
//  Created by Pedro Giuliano Farina on 04/11/19.
//  Copyright © 2019 Pedro Giuliano Farina. All rights reserved.
//

import SceneKit
import ARKit

extension float4x4 {
    var translation: SCNVector3 {
        let translation = self.columns.3
        return SCNVector3(translation.x, translation.y, translation.z)
    }
}
