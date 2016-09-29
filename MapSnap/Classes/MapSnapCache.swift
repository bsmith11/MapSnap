//
//  MapSnapCache.swift
//  Pods
//
//  Created by Bradley Smith on 9/28/16.
//
//

import Foundation

public protocol MapSnapCache {
    func objectForKey(key: String) -> AnyObject?
    func setObject(object: NSCoding, forKey: String)
}
