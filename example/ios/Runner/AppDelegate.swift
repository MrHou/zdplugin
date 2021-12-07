import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   
     GeneratedPluginRegistrant.register(with: self)
    //https://stackoverflow.com/questions/45645866/how-can-i-push-a-uiviewcontroller-from-flutterviewcontroller
    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
     let navigationController = UINavigationController(rootViewController: flutterViewController)
     navigationController.isNavigationBarHidden = true
      
      if let tabBar = (navigationController.tabBarController?.tabBar){
          let numberOfItems = CGFloat((tabBar.items!.count))
              let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
              tabBar.selectionIndicatorImage = UIImage.imageWithColor(UIColor.lightText.withAlphaComponent(0.5), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
              
        
      }
      navigationController.tabBarController?.view = UIView()
      if #available(iOS 13.0, *) {
          let appearance = UINavigationBarAppearance()
          appearance.configureWithOpaqueBackground()
          appearance.backgroundColor = UIColor.red
          navigationController.navigationBar.standardAppearance = appearance;
          navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
      } else {
          // Fallback on earlier versions
      }
  
     window?.rootViewController = navigationController
     window?.makeKeyAndVisible()
      
    window?.rootViewController?.navigationController?.isNavigationBarHidden = true
              
    UITabBar.appearance().tintColor = UIColor.purple
    UITabBar.appearance().selectionIndicatorImage = UIImage()
     
     return super.application(application,     didFinishLaunchingWithOptions: launchOptions)
  }
  
}

extension UIImage {
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
