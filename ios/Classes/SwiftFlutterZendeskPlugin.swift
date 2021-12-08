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
// ViewController and engines
import SwiftUI
// Theme
import CommonUISDK
import SwiftUI

public class SwiftFlutterZendeskPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
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
            let jwtToken = dic["jwtToken"] as? String ?? ""
            
            if(accountKey.isEmpty || applicationId.isEmpty || clientId.isEmpty || domainUrl.isEmpty || jwtToken.isEmpty ){
                result(false)
                return;
            }
            Zendesk.initialize(appId: applicationId,
                               clientId: clientId,
                               zendeskUrl: domainUrl)
            
            Support.initialize(withZendesk: Zendesk.instance)
            AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
            
            let idendity =  Identity.createJwt(token: jwtToken)
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
            result(true)
        case "startChatV1":
            startChatV1()
        case "startChatV2":
            guard let dic = call.arguments as? Dictionary<String, Any> else { return }
            let botLabel = dic["botLabel"] as? String ?? "Jasper"
            let phone = dic["phone"] as? String ?? ""
            let email = dic["email"] as? String ?? ""
            let name = dic["name"] as? String ?? ""
            let department = dic["departmentName"] as? String ?? ""
            let toolbarTitle = dic["toolbarTitle"] as? String ?? ""
            let endChatSwitch = dic["endChatSwitch"] as? String ?? ""
            let iosToolbarHashColor = dic["iosToolbarHashColor"] as? String ?? "#922C3E"
            
            
            
            setVisitorInfo(name: name, email: email, phoneNumber: phone, departmentName: department, tags: [])
            print(Chat.instance?.profileProvider.visitorInfo);
            do {
                try startChatV2(botLabel: botLabel, iosToolbarHashColor: iosToolbarHashColor,iosToolbarName: toolbarTitle)
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
        //chatAPIConfiguration.tags = ["support"]
        chatAPIConfiguration.visitorInfo = visitorInfo
//        chatAPIConfiguration.department = departmentName
        Chat.instance?.configuration = chatAPIConfiguration
        
        var token: ChatProvidersSDK.ObservationToken?
        token = Chat.connectionProvider?.observeConnectionStatus { status in
            guard status.isConnected else { return }
            
            Chat.profileProvider?.setVisitorInfo(visitorInfo, completion: nil)
            Chat.profileProvider?.setNote("Visitor from Jasper app")
            token?.cancel() // Ensure call only happens once
        }
    }
    
    func startChatV2(botLabel:String, iosToolbarHashColor: String,iosToolbarName: String) throws {
        let chatFormConfiguration = ChatSDK.ChatFormConfiguration(name: .optional, email: .optional, phoneNumber: .optional,department: .optional)
        //
        let chatConfiguration = ChatConfiguration()
        
        //If true, visitors will be prompted at the end of their chat asking them whether they would like a transcript sent by email.
        chatConfiguration.isChatTranscriptPromptEnabled = true
        //If true, visitors are prompted for information in a conversational manner prior to starting the chat. Defaults to true.
        chatConfiguration.isPreChatFormEnabled = false
        //If this flag is enabled (as well as isAgentAvailabilityEnabled) then visitors will be presented with a form allowing them to leave a message if no agents are available. This will create a support ticket. Defaults to true.
        chatConfiguration.isOfflineFormEnabled = true
        //If true, and no agents are available to serve the visitor, they will be presented with a message letting them know that no agents are available. If it's disabled, visitors will remain in a queue waiting for an agent. Defaults to true.
        chatConfiguration.isAgentAvailabilityEnabled = true
        //This property allows you to configure the requirements of each of the pre-chat form fields.
        
        chatConfiguration.preChatFormConfiguration = chatFormConfiguration
        // Name for Bot messages
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = botLabel
        
        
        let chatEngine = try ChatEngine.engine()
        
        CommonTheme.currentTheme.primaryColor = UIColor.red
        var viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration,chatConfiguration])
        
        if #available(iOS 14.0, *) {
            viewController = UIHostingController(rootView: ZendeskNavigationView(with: viewController, toolbarHashColor: iosToolbarHashColor, toolbarName: iosToolbarName).body)
        } else {
            
        }
        
        Chat.connectionProvider?.observeConnectionStatus({ s in
            print("connections tstaus: \(s)")
        })
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            
            viewController.modalPresentationStyle = .fullScreen
            navigationController.present(viewController, animated: true, completion: nil)
        }
    }
    
    
}

