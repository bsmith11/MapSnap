//
//  MKMapSnapshotter+MapSnap.swift
//  Pods
//
//  Created by Bradley Smith on 9/27/16.
//
//

import MapKit

public typealias MapSnapshotterCompletion = (UIImage?, Error?) -> Void

public extension MKMapSnapshotter {
    static func imageForCoordinate(_ coordinate: CLLocationCoordinate2D, size: CGSize, completion: MapSnapshotterCompletion?) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let options = MKMapSnapshotOptions()
        options.region = region
        options.size = size
        
        let snapshotter = MKMapSnapshotter(options: options)
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        snapshotter.start(with: queue, completionHandler: { (snapshot: MKMapSnapshot?, error: Error?) in
            guard let snapshot = snapshot else {
                DispatchQueue.main.async(execute: {
                    completion?(nil, error)
                })
                
                return
            }
            
            let image = snapshot.image
            let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
            
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(at: .zero)
            
            var point = snapshot.point(for: coordinate)
            let visibleRect = CGRect(origin: .zero, size: image.size)
            
            if visibleRect.contains(point) {
                point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2.0)
                point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2.0)
                pin.image?.draw(at: point)
            }
            
            let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async(execute: {
                completion?(compositeImage, nil)
            })
        })
    }
}
