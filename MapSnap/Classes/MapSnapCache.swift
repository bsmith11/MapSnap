//
//  MapSnapCache.swift
//  Pods
//
//  Created by Bradley Smith on 9/28/16.
//
//

import Foundation

public protocol MapSnapCache {
    func object(for key: String) -> Any?
    func set(object: NSCoding, for key: String)
}
