# MapSnap

[![CI Status](http://img.shields.io/travis/Brad Smith/MapSnap.svg?style=flat)](https://travis-ci.org/Brad Smith/MapSnap)
[![Version](https://img.shields.io/cocoapods/v/MapSnap.svg?style=flat)](http://cocoapods.org/pods/MapSnap)
[![License](https://img.shields.io/cocoapods/l/MapSnap.svg?style=flat)](http://cocoapods.org/pods/MapSnap)
[![Platform](https://img.shields.io/cocoapods/p/MapSnap.svg?style=flat)](http://cocoapods.org/pods/MapSnap)

## Requirements

MapSnap requires at least iOS 8 and Swift 2.3

## Installation

MapSnap is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MapSnap"
```

## Usage

`UIImageView` extensions to generate, cache, and set a map image based on a `CLLocationCoordinate2D`

```swift
let mapImageView = UIImageView(frame: .zero)
let latitude = 42.3601
let longitude = 71.0589
let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
mapImageView.setMapImageWithCoordinate(coordinate)
```

Optionally specify:
* image size
* placeholder image to use while the map image is asynchronously generated

```swift
let size = CGSizeMake(width: UIScreen.mainScreen().bounds.width, height: 200.0)
let placeholderImage = UIImage(named: "my_placeholder_image")
mapImageView.setMapImageWithCoordinate(coordinate, size: size, placeholderImage: placeholderImage)
```

`MapSnapManager` may be used directly to generate and cache map images. The default image size is customizable and has a default value of:

```swift
public var defaultImageSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 150.0)
```

The default cache used is [PINCache](https://github.com/pinterest/PINCache), but you can subsitute it with anything that conforms to the `MapSnapCache` protocol:

```swift
public protocol MapSnapCache {
    func objectForKey(key: String) -> AnyObject?
    func setObject(object: NSCoding, forKey: String)
}
```

## Author

Brad Smith, [@bsmithers11](https://twitter.com/bsmithers11)

## License

MapSnap is available under the MIT license. See the LICENSE file for more info.
