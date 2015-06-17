//
//  Types.swift
//  PestControl
//
//  Created by Norman Croan on 5/19/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

struct PhysicsCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Boundary : UInt32 = 0b1 // 1
    //static let Player   : UInt32 = 0b10 // 2
    static let Player   : UInt32 = 0b10 // 2
    static let Floor    : UInt32 = 0b100 // 4
    static let Bounce   : UInt32 = 0b10000 // 8
}
