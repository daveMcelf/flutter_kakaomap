import Flutter
import UIKit


public class SwiftMaptestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "maptest", binaryMessenger: registrar.messenger())
    
    //let instance = MapView()
    registrar.register(MapViewFactory(registra: registrar), withId: "KakaoMapPlugin")
    //registrar.addMethodCallDelegate(instance, channel: channel)
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
    if (call.method == "loadMap") {
        print("load")
        //result()
        let main = UIViewController(nibName: nil, bundle: nil)
        let map = MTMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) )
        main.view.addSubview(map)
        //let alert = UIAlertController(title: "Sample", message: "Sample", preferredStyle: .alert)
        //self.viewController(with: nil)?.present(main, animated: true, completion: nil)
        result(main)
    }
  }
    func viewController(with window: UIWindow?) -> UIViewController? {
        var windowToUse = window
        if windowToUse == nil {
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    windowToUse = window
                    break
                }
                
            }
        }
        

        var topController = windowToUse?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }
}

class MapViewFactory: NSObject, FlutterPlatformViewFactory {
    private var mPluginRegistra: FlutterPluginRegistrar
    init(registra: FlutterPluginRegistrar) {
        self.mPluginRegistra = registra
        super.init()
        
    }
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
//        let channel = FlutterMethodChannel(name: "maptest_\(viewId)", binaryMessenger: mPluginRegistra.messenger())
//
//        let instance = MapView()
        return MapView.init(withFrame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: mPluginRegistra.messenger())
    }
    
    
}

public class MapView: NSObject, FlutterPlatformView {
    var map: MTMapView?
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messeger: FlutterBinaryMessenger) {
        super.init()
        
        map = MTMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100) )
        map?.baseMapType = .standard
        map?.showCurrentLocationMarker = true
        
        //map?.delegate = self
        let channel = FlutterMethodChannel(name: "maptest_\(viewId)", binaryMessenger: messeger)
        channel.setMethodCallHandler({ (call, result) in
            self.onMethodcall(call, result: result)
        });
        
        //print(self.view().bounds)
        
    }
    
    func onMethodcall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "loadMap" {
            print("wowowow")
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "setZoomLevel"{
            if let map = map {
                //map.setZoomLevel(4, animated: true)
                let point1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.541889, longitude: 127.095388))
                let point2 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.537229, longitude: 127.005515) )
                
                let poi1 = MTMapPOIItem.init()
                poi1.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo.init(latitude: 37.541889, longitude: 127.095388) )
                poi1.markerType = .customImage
                //poi1.markerSelectedType = .bluePin
                poi1.customImageName = "map_pin_custom.png"
                poi1.showAnimationType = .dropFromHeaven
                poi1.tag = 153
                poi1.itemName = "city hall"
                poi1.draggable = true
                
                
                let poi2 = MTMapPOIItem()
                poi2.mapPoint = point2
                poi2.markerType = .redPin
                poi2.markerSelectedType = .bluePin
                poi2.showAnimationType = .dropFromHeaven
                poi2.tag = 154
                poi2.itemName = "city hall1"
                poi2.draggable = true
                
                //let mapbound = MTMapBounds(bottoomLeft: point1_a, topRight: point2_a)
                let mapg = MTMapBoundsRect()
                mapg.bottomLeft = point1
                mapg.topRight = point2
                let camer = MTMapCameraUpdate.fitMapView(withMapBounds: mapg, withPadding: 100, withMinZoomLevel: 5, withMaxZoomLevel: 7)
//                let camera = MTMapCameraUpdate.fitMapView(mapbound, withPadding: 100, withMinZoomLevel: 3, withMaxZoomLevel: 7)
                
                map.addPOIItems([poi1, poi2])
                
                
                map.fitAreaToShowAllPOIItems()
                map.refreshMapTiles()
                self.map = map
                //map.animate(with: camer)
                result(nil)
            
                
            } else {
                result(FlutterMethodNotImplemented)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    public func view() -> UIView {
        //let map = MTMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 100) )
        return map ?? UIView()
    }
    

}
