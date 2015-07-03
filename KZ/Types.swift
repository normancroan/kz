//
//  Types.swift
//  PestControl
//
//  Created by Norman Croan on 5/19/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

//Note: Currently using Floor/Player/Wall from SKATK
struct PhysicsCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Boundary : UInt32 = 0b1 // 1
    static let Player   : UInt32 = 0b10 // 2
    static let Floor    : UInt32 = 0b100 // 4
    static let Bounce   : UInt32 = 0b10000 // 8
    static let Item     : UInt32 = 0b100000000 // 16
    static let Sensor   : UInt32 = 0b10000000000000000 // 32
}
