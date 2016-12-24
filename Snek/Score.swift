//
//  Score.swift
//  Snek
//
//  Created by Luigi Sansonetti on 14.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import Foundation

class Score: NSObject, NSCoding {
    
    // MARK: Properties
    
    var name: String?
    var result: Int?
    
    // MARK: Initializer
    
    init(name: String, result: Int) {
        self.result = result
        self.name = name
        
        super.init()
    }
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("scores")
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(result, forKey: PropertyKey.resultKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let result = aDecoder.decodeObject(forKey: PropertyKey.resultKey) as! Int
        
        self.init(name: name, result: result)
    }
}
