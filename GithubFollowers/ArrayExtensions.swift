//
//  ArrayExtensions.swift
//  GithubFollowers
//
//  Created by Shelly Gupta on 12/12/21.
//

import Foundation

extension Array {
    func customFilter(_ completion: (Element) -> Bool) -> [Element] {
        
        var resultedArray = [Element]()
        
        self.forEach {
            if completion($0) {
                resultedArray.append($0)
            }
        }
        
        return resultedArray
    }
    
    func customMap<T>(_ transform: (Element) -> T) -> [T] {
        
        var resultedArray = [T]()
        
        self.forEach {
            resultedArray.append(transform($0))
        }
        
        return resultedArray
    }
}
