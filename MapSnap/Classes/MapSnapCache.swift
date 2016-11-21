//
//  MapSnapCache.swift
//  Pods
//
//  Created by Bradley Smith on 9/28/16.
//
//

import Foundation

public protocol MapSnapCache {
    func object(forKey key: String) -> Any?
    func setObject(_ object: NSCoding, forKey: String)
}
