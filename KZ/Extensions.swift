//
//  Extensions.swift
//  KZ
//
//  Created by Norman Croan on 7/6/15.
//  Copyright (c) 2015 Norman Croan. All rights reserved.
//

import Foundation

extension String {
    init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in enumerate(lines) {
            self += "\(item)"
            if idx < lines.count-1 {
                self += sep
            }
        }
    }
    
    init(_ lines:String...){
        self = ""
        for (idx, item) in enumerate(lines) {
            self += "\(item)"
            if idx < lines.count-1 {
                self += "\n"
            }
        }
    }
}
/*
println(String("Hello","Darkness","My","Old","Friend"))

prints:

Hello
Darkness
My
Old
Friend
*/
