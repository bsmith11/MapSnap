Pod::Spec.new do |s|
  s.name                  = 'MapSnap'
  s.version               = '0.2.0'
  s.summary               = 'A library to easily create map snapshots'
  s.description           = <<-DESC
                            MapSnap lets you easily create map snapshots, cache them, and display them in UIImageViews
                            DESC
  s.homepage              = 'https://github.com/bsmith11/MapSnap'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Brad Smith' => 'bradley.d.smith11@gmail.com' }
  s.source                = { :git => 'https://github.com/bsmith11/MapSnap.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files          = 'MapSnap/Classes/**/*'
  s.requires_arc          = true
  s.frameworks            = 'UIKit', 'MapKit', 'CoreLocation'

  s.dependency 'PINCache', '~> 2.3'
end
