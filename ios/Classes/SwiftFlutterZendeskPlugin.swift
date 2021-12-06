import Flutter
import UIKit
import SupportSDK
import ChatSDK
import ChatProvidersSDK
import MessagingSDK
import MessagingAPI
import SDKConfigurations
import ZendeskCoreSDK
import SupportProvidersSDK
//import ZendeskSDKMessaging
//import ZendeskSDKLogger

import AnswerBotProvidersSDK
import AnswerBotSDK
//import ZDCChat
// ViewController and engines

// Theme
import CommonUISDK

public class SwiftFlutterZendeskPlugin: NSObject, FlutterPlugin {
    
    var authToken = "{\"id\": \"73e75714-bbf7-4596-8212-8b0164f1ed97\", \"hash\": \"bb5bcaebddd7f5c956235bf05d13cdd2c20e6004a546e2b73a351b4b15fa5feb\"}"
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        UITabBar.appearance().backgroundColor = UIColor.red
        UITabBar.appearance().tintColor = UIColor.red
        let channel = FlutterMethodChannel(name: "flutter_zendes_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterZendeskPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "getPlatformVersion":
         
            result("IOS")
        case "init":
            Logger.isEnabled = true
            Logger.defaultLevel = .verbose
          
            guard let dic = call.arguments as? Dictionary<String, Any> else { return }
            
            let accountKey = dic["accountKey"] as? String ?? ""
            let applicationId = dic["applicationId"] as? String ?? ""
            let clientId = dic["clientId"] as? String ?? ""
            let domainUrl = dic["domainUrl"] as? String ?? ""
            let emailIdentifier = dic["emailIdentifier"] as? String ?? "emailIdentifier"
            let nameIdentifier = dic["nameIdentifier"] as? String ?? "nameIdentifier"
            
            let phone = dic["phone"] as? String ?? ""
            let email = dic["email"] as? String ?? ""
            let name = dic["name"] as? String ?? ""
//            postAction(url: domainUrl)
//            Zendesk.initialize(appId: applicationId,
//                clientId: clientId,
//                zendeskUrl: domainUrl)
            Zendesk.initialize(appId: "be5a52ed9dbb9f19e38dd4a191b5fa79018c4710dbc5487d",
                clientId: "mobile_sdk_client_2bb73df48f963be15710",
                zendeskUrl: "https://hellojasper.zendesk.com")

            Support.initialize(withZendesk: Zendesk.instance)
            AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)

            let idendity =  Identity.createJwt(token: authToken)
            Zendesk.instance?.setIdentity(idendity)
//            let identity = Identity.createAnonymous(name: "Dmytro Diachenko", email: "testtest@test.com")
//            Zendesk.instance?.setIdentity(identity)
////
//            //V1 Chat
//            ZDCChat.initialize(withAccountKey: accountKey)
//            ZDCChat.updateVisitor { user in
//                user?.phone = phone
//                user?.name = name
//                user?.email = email
//            }
            //CHAT V2 SDK
            Chat.initialize(accountKey: accountKey)
            result("iOS init completed" )
        case "startChatV1":
            startChatV1()
        case "startChatV2":
            guard let dic = call.arguments as? Dictionary<String, Any> else { return }
            let botLabel = dic["botLabel"] as? String ?? "Jasper"
            let phone = dic["phone"] as? String ?? ""
            let email = dic["email"] as? String ?? ""
            let name = dic["name"] as? String ?? ""
            let department = dic["departmentName"] as? String ?? ""
           
            setVisitorInfo(name: name, email: email, phoneNumber: phone, departmentName: department, tags: [])
            print(Chat.instance?.profileProvider.visitorInfo);
            do {
                try startChatV2(botLabel: botLabel)
            } catch let error{
                print("error:\(error)")
            }
            
        case "helpCenter":
            let currentVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            let hcConfig = HelpCenterUiConfiguration()
            hcConfig.showContactOptions = true
            let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [hcConfig])
            currentVC?.pushViewController(helpCenter, animated: true)
            result("iOS helpCenter UI:" + helpCenter.description + "   ")
        case "requestView":
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            
            let viewController = RequestUi.buildRequestUi(with: [])
            
            rootViewController?.pushViewController(viewController, animated: true)
        case "requestListView":
            setVisitorInfo(name: "name", email: "email", phoneNumber: "34235435", departmentName: "Support", tags: [])
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            
            let viewController = RequestUi.buildRequestList(with: [])
            rootViewController?.pushViewController(viewController, animated: true)
        case "changeNavStatus":
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            guard let dic = call.arguments as? Dictionary<String, Any> else { return }
            
            let isShow = dic["isShow"] as? Bool ?? false
            rootViewController?.setNavigationBarHidden(!isShow, animated: false)
            result("rootViewController?.isNavigationBarHidden = isShow >>>>>")
            
        default:
            break
        }
    }
    func startChatV1(){
        //https://developer.zendesk.com/embeddables/docs/ios-chat-sdk/chat
        
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        
//        ZDCChat.start(in: navigationController, withConfig: {config in
//            config?.preChatDataRequirements.name = .notRequired
//            config?.preChatDataRequirements.email = .notRequired
//            config?.preChatDataRequirements.phone = .requiredEditable
//        })
//
////         Hides the back button because we are in a tab controller
//                ZDCChat.instance().chatViewController.navigationItem.hidesBackButton = true
    }
    
    func setVisitorInfo(name:String,email:String,phoneNumber: String,departmentName: String,tags:Array<String>) -> Void {
//        Chat.instance?.clearCache()
//        Chat.instance?.resetIdentity(nil)
//        print("indentity \(Chat.instance?.hasIdentity)")
        let visitorInfo = VisitorInfo.init(name: name, email: email, phoneNumber: phoneNumber)
            let chatAPIConfiguration = ChatAPIConfiguration()
//            chatAPIConfiguration.tags = ["support"]
            chatAPIConfiguration.visitorInfo = visitorInfo
//            chatAPIConfiguration.department = "Support"
         Chat.instance?.configuration = chatAPIConfiguration
        
        }
    
    func startChatV2(botLabel:String) throws {
        let chatFormConfiguration = ChatSDK.ChatFormConfiguration(name: .optional, email: .optional, phoneNumber: .optional,department: .optional)
//
        let chatConfiguration = ChatConfiguration()

        //If true, visitors will be prompted at the end of their chat asking them whether they would like a transcript sent by email.
        chatConfiguration.isChatTranscriptPromptEnabled = true
        //If true, visitors are prompted for information in a conversational manner prior to starting the chat. Defaults to true.
        chatConfiguration.isPreChatFormEnabled = true
        //If this flag is enabled (as well as isAgentAvailabilityEnabled) then visitors will be presented with a form allowing them to leave a message if no agents are available. This will create a support ticket. Defaults to true.
        chatConfiguration.isOfflineFormEnabled = true
        //If true, and no agents are available to serve the visitor, they will be presented with a message letting them know that no agents are available. If it's disabled, visitors will remain in a queue waiting for an agent. Defaults to true.
        chatConfiguration.isAgentAvailabilityEnabled = true
        //This property allows you to configure the requirements of each of the pre-chat form fields.

        chatConfiguration.preChatFormConfiguration = chatFormConfiguration
        chatConfiguration.isPreChatFormEnabled = false
        // Name for Bot messages
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = botLabel
        


        let chatEngine = try ChatEngine.engine()
        
        CommonTheme.currentTheme.primaryColor = UIColor.red

        let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration,chatConfiguration])
       

        Chat.connectionProvider?.observeConnectionStatus({ s in
            print("connections tstaus: \(s)")
        })

            let rootViewController = UIApplication.shared.windows.filter({ (w) -> Bool in
                      return w.isHidden == false
                  }).first?.rootViewController

            self.presentViewController(rootViewController: rootViewController, view: viewController);
        
    }
    
    
    func presentViewController(rootViewController: UIViewController?, view: UIViewController) {
    

       
           if (rootViewController is UINavigationController) {
               let root = (rootViewController as! UINavigationController)
               root.tabBarController?.tabBar.tintColor = UIColor.red
               root.tabBarController?.tabBar.backgroundColor = UIColor.green
               root.tabBarController?.tabBar.barTintColor = UIColor.yellow
               root.tabBarController?.tabBar.isTranslucent = false
              
               root.pushViewController(view, animated: true)
           } else {
               if #available(iOS 13.0, *) {
                    if var topController = UIApplication.shared.keyWindow?.rootViewController  {
                          while let presentedViewController = topController.presentedViewController {
                                topController = presentedViewController
                               }
                    topController.present(view, animated: true, completion: nil)
               }

           }
       }
  
       }
    
}

extension Bundle {
    public var appIcon: UIImage? {
        if let appIcons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryAppIcon = appIcons["CFBundlePrimaryIcon"] as? [String: Any],
            let appIconFiles = primaryAppIcon["CFBundleIconFiles"] as? [String],
            let lastAppIcon = appIconFiles.last {
            return UIImage(named:lastAppIcon)
        }
        return nil
    }
}
