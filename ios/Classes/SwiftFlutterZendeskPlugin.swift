import Flutter
import UIKit
//import SupportSDK
//import ChatSDK
//import ChatProvidersSDK
//import MessagingSDK
//import MessagingAPI
//import SDKConfigurations
//import ZendeskCoreSDK
//import SupportProvidersSDK
import ZendeskSDKMessaging
import ZendeskSDKLogger

//import AnswerBotProvidersSDK
//import AnswerBotSDK
//import ZDCChat
// ViewController and engines

// Theme
//import CommonUISDK
//import ChatProvidersSDK
public class SwiftFlutterZendeskPlugin: NSObject, FlutterPlugin {
    let key = "eyJzZXR0aW5nc191cmwiOiJodHRwczovL3Rlc3Rkb21haW5teWRvbWFpbnRlc3RldHN0Z2hoZWxwLnplbmRlc2suY29tL21vYmlsZV9zZGtfYXBpL3NldHRpbmdzLzAxRk5XNEtRTVdUUEJZQTZLODJaRFdXTjJLLmpzb24ifQ=="
    
    
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
//            Logger.isEnabled = true
//            Logger.defaultLevel = .verbose
            Logger.enabled = true
            Logger.level = .default
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
//            Zendesk.initialize(appId: "dcc73c89a0d6c3c05de0729f05d9c78bc867ca164e743ee6",
//                clientId: "mobile_sdk_client_7211ae5f16806b37b91f",
//                zendeskUrl: "https://testdomainmydomaintestetstghhelp.zendesk.com")
//            Support.initialize(withZendesk: Zendesk.instance)
//            AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
          
//            var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MzgzNDMyMzcsImp0aSI6ImM1YTExYTA2LWVjNzgtNDkyMi1iNzEyLTgxYTk3OWYzYzI1MyIsImVtYWlsIjoidGVzdHRlc3RAdGVzdC5jb20iLCJuYW1lIjoiRCBEaWFjbmtvIiwiZXh0ZXJuYWxfaWQiOiI5OGJjNTE5ZS05ZWFmLTRkNzAtYmVkOS1lNjY4OTk2NTNlOGYiLCJwaG9uZSI6IisxMzEyMzEyMzEyMyIsInJvbGUiOiJhZG1pbiIsInVzZXJfZmllbGRzIjp7InByaW1hcnlfam91cm5leV9pZCI6IjNlYzAzNDRlLWYyNzQtNDRmZC1iYzA0LWI2ODdkMmIzMjY2MyJ9fQ.eSE8yIcKrjizWgcomFYFxUdF-aM4784MB7D0UTLdRsw"
//            Zendesk.instance?.setIdentity(Identity.createJwt(token: token))
//            let identity = Identity.createAnonymous(name: "Dmytro Diachenko", email: "testtest@test.com")
//            Zendesk.instance?.setIdentity(identity)
//
//            //V1 Chat
//            ZDCChat.initialize(withAccountKey: accountKey)
//            ZDCChat.updateVisitor { user in
//                user?.phone = phone
//                user?.name = name
//                user?.email = email
//            }
            //CHAT V2 SDK
//            Chat.initialize(accountKey: accountKey,appId:applicationId)
           
            Messaging.initialize(channelKey:key) { result in
                        // Tracking the error from initialization failures in your
                        // crash reporting dashboard will help to triage any unexpected failures in production
                       if case let .failure(error) = result {
                           print("Messaging did not initialize.\nError: \(error.errorDescription ?? "")")
                       }
                   }
//
//            var token: ChatProvidersSDK.ObservationToken?
//              token = Chat.connectionProvider?.observeConnectionStatus { status in
//                  guard status.isConnected else { return }
//
//                  Chat.chatProvider?.setDepartment("Support", completion: {res in
//                      print(res)
//                  })
//                  Chat.profileProvider?.setNote("Visitor Notes")
//                  token?.cancel() // Ensure call only happens once
//              }
           
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
//            print(Chat.instance?.profileProvider.visitorInfo);
            do {
                try startChatV2(botLabel: botLabel)
               
            } catch let error{
                print("error:\(error)")
            }
            
        case "helpCenter":
            let currentVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//            let hcConfig = HelpCenterUiConfiguration()
//            hcConfig.showContactOptions = true
//            let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [hcConfig])
//            currentVC?.pushViewController(helpCenter, animated: true)
//            result("iOS helpCenter UI:" + helpCenter.description + "   ")
        case "requestView":
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            
//            setVisitorInfo(name: "name", email: "email", phoneNumber: "34235435", departmentName: "Support", tags: [])
//
//            let chatFormConfiguration = ChatSDK.ChatFormConfiguration(name: .required, email: .required, phoneNumber: .optional,department: .hidden)
//            let chatConfiguration = ChatConfiguration()
//
//            //If true, visitors will be prompted at the end of their chat asking them whether they would like a transcript sent by email.
//            chatConfiguration.isChatTranscriptPromptEnabled = true
//            //If true, visitors are prompted for information in a conversational manner prior to starting the chat. Defaults to true.
//            chatConfiguration.isPreChatFormEnabled = true
//            //If this flag is enabled (as well as isAgentAvailabilityEnabled) then visitors will be presented with a form allowing them to leave a message if no agents are available. This will create a support ticket. Defaults to true.
//            chatConfiguration.isOfflineFormEnabled = true
            //If true, and no agents are available to serve the visitor, they will be presented with a message letting them know that no agents are available. If it's disabled, visitors will remain in a queue waiting for an agent. Defaults to true.
//            chatConfiguration.isAgentAvailabilityEnabled = true
//            //This property allows you to configure the requirements of each of the pre-chat form fields.
//
//            chatConfiguration.preChatFormConfiguration = chatFormConfiguration
//
//            let viewController = RequestUi.buildRequestUi(with: [])
//            RequestUi.initialize()
//            rootViewController?.pushViewController(viewController, animated: true)
        case "requestListView":
            setVisitorInfo(name: "name", email: "email", phoneNumber: "34235435", departmentName: "Support", tags: [])
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
//            let chatFormConfiguration = ChatSDK.ChatFormConfiguration(name: .optional, email: .optional, phoneNumber: .optional,department: .hidden)
//            let chatConfiguration = ChatConfiguration()
//
//            //If true, visitors will be prompted at the end of their chat asking them whether they would like a transcript sent by email.
//            chatConfiguration.isChatTranscriptPromptEnabled = true
//            //If true, visitors are prompted for information in a conversational manner prior to starting the chat. Defaults to true.
//            chatConfiguration.isPreChatFormEnabled = true
//            //If this flag is enabled (as well as isAgentAvailabilityEnabled) then visitors will be presented with a form allowing them to leave a message if no agents are available. This will create a support ticket. Defaults to true.
//            chatConfiguration.isOfflineFormEnabled = true
//            //If true, and no agents are available to serve the visitor, they will be presented with a message letting them know that no agents are available. If it's disabled, visitors will remain in a queue waiting for an agent. Defaults to true.
//            chatConfiguration.isAgentAvailabilityEnabled = true
//            //This property allows you to configure the requirements of each of the pre-chat form fields.
//
//            chatConfiguration.preChatFormConfiguration = chatFormConfiguration
            
//            let viewController = RequestUi.buildRequestList(with: [])
//            rootViewController?.pushViewController(viewController, animated: true)
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
//        print("indentity \(Chat.instance?.hasIdentity)")
//        let visitorInfo = VisitorInfo.init(name: name, email: email, phoneNumber: phoneNumber)
//            let chatAPIConfiguration = ChatAPIConfiguration()
////            chatAPIConfiguration.tags = ["support"]
////            chatAPIConfiguration.visitorInfo = visitorInfo
////            chatAPIConfiguration.department = "All department"
//        if let instance = Chat.instance {
//            print("set up visitor info sucess")
//            instance.configuration = chatAPIConfiguration
//
//        }else{
//            print("set up visitor info ERORRR")
//        }
        
//        var token: ChatProvidersSDK.ObservationToken?
//        token = Chat.connectionProvider?.observeConnectionStatus { status in
//               guard status.isConnected else { return }
//               let visitorInfo = VisitorInfo(name: "fwfw", email: "email@fkjwnf.fl", phoneNumber: "938423847623846")
//               Chat.profileProvider?.addTags(["app"])
//               Chat.profileProvider?.setNote("Visitor Notes")
//               print("set up visitor info...")
//               Chat.profileProvider?.setVisitorInfo(visitorInfo, completion: {(mm)in
//                   print("set up visitor info...SUCESSS")
//               })
//
//               token?.cancel() // Ensure call only happens once
//           }
//        Chat.connectionProvider?.connect()

     
        }
    
    func startChatV2(botLabel:String) throws {
//        let chatFormConfiguration = ChatSDK.ChatFormConfiguration(name: .optional, email: .optional, phoneNumber: .optional,department: .hidden)
////
//        let chatConfiguration = ChatConfiguration()
//
//        //If true, visitors will be prompted at the end of their chat asking them whether they would like a transcript sent by email.
//        chatConfiguration.isChatTranscriptPromptEnabled = false
//        //If true, visitors are prompted for information in a conversational manner prior to starting the chat. Defaults to true.
//        chatConfiguration.isPreChatFormEnabled = true
//        //If this flag is enabled (as well as isAgentAvailabilityEnabled) then visitors will be presented with a form allowing them to leave a message if no agents are available. This will create a support ticket. Defaults to true.
//        chatConfiguration.isOfflineFormEnabled = true
//        //If true, and no agents are available to serve the visitor, they will be presented with a message letting them know that no agents are available. If it's disabled, visitors will remain in a queue waiting for an agent. Defaults to true.
//        chatConfiguration.isAgentAvailabilityEnabled = true
//        //This property allows you to configure the requirements of each of the pre-chat form fields.
//
//        chatConfiguration.preChatFormConfiguration = chatFormConfiguration
//        chatConfiguration.isPreChatFormEnabled = true
//        // Name for Bot messages
//        let messagingConfiguration = MessagingConfiguration()
//        messagingConfiguration.name = botLabel
//        messagingConfiguration.isMultilineResponseOptionsEnabled = true
//
//
////        let answerBotEngine = try AnswerBotEngine.engine()
//        let chatEngine = try ChatEngine.engine()
        
//        CommonTheme.currentTheme.primaryColor = UIColor.green
       
//        let viewController = try Messaging.instance.buildUI(engines: [chatEngine], configs: [messagingConfiguration])
//        Messaging.instance.delegate = self
       
//        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//
//            navigationController.pushViewController(viewController, animated: true)
//
//        }
//        Chat.connectionProvider?.observeConnectionStatus({ s in
//            print("connections tstaus: \(s)")
//        })
       
//        Chat.connectionProvider?.connect()
        let rootViewController = UIApplication.shared.windows.filter({ (w) -> Bool in
                  return w.isHidden == false
              }).first?.rootViewController
        guard let viewController = Messaging.instance?.messagingViewController() else { return }
        presentViewController(rootViewController: rootViewController, view: viewController);
       
       
//        Chat.chatProvider?.sendMessage("tet") { (result) in
//                    switch result {
//                    case .success(let messageId):
//                        NSLog("Message sent: %@", messageId)
//                    case .failure(let error):
//                        NSLog("Send failed, resending....")
//                        let messageId = error.messageId
//                        if messageId != nil && !(messageId?.isEmpty ?? false) {
//                            Chat.chatProvider?.resendFailedFile(withId: messageId!)
//                        }
//                    }
//                }
        
    }
    
    
    func presentViewController(rootViewController: UIViewController?, view: UIViewController) {
           if (rootViewController is UINavigationController) {
               (rootViewController as! UINavigationController).pushViewController(view, animated: true)
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
    
    func postAction(url:String) {
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = {}
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
       
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
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

//extension SwiftFlutterZendeskPlugin {
//
//    var engines: [Engine] {
//        let engineTypes: [Engine.Type] = [ChatEngine.self]
//        return engines(from: engineTypes)
//    }
//
//    func engines(from engineTypes: [Engine.Type]) -> [Engine] {
//        engineTypes.compactMap { type -> Engine? in
//            switch type {
//            case is ChatEngine.Type:
//                return try? ChatEngine.engine()
//            default:
//                fatalError("Unhandled engine of type: \(type)")
//            }
//        }
//    }
//}

