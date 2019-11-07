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
    var translation: SIMD3<Float> {
        get {
            let translation = columns.3
            return [translation.x, translation.y, translation.z]
        }
        set(newValue) {
            columns.3 = [newValue.x, newValue.y, newValue.z, columns.3.w]
        }
    }

    var orientation: simd_quatf {
        return simd_quaternion(self)
    }
}
