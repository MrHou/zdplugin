//
//  ZendeskControllerWrapper.swift
//  flutter_zendes_plugin
//
//  Created by Dmitry Dyachenko on 07.12.2021.
//

import SwiftUI
import SupportSDK
import ChatSDK
import ChatProvidersSDK
import MessagingSDK
import MessagingAPI
import SDKConfigurations
import ZendeskCoreSDK
import CommonUISDK

@available(iOS 13.0, *)
let coloredNavAppearance = UINavigationBarAppearance()

@available(iOS 13.0.0, *)
struct ZendeskNavigationView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var withViewController: UIViewController

    
    init(with _withViewController:UIViewController ) {
        //MARK: zendesk didn't change tabbar style by default
//        coloredNavAppearance.configureWithOpaqueBackground()
//        coloredNavAppearance.backgroundColor = .red
//        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        withViewController =  _withViewController
    }

    @available(iOS 13.0.0, *)
    var body: some View {
        NavigationView{
           
            if #available(iOS 14.0, *) {
                contentMy
                    .hideNavigationBar()
                    .ignoresSafeArea()
               
            } else {
                contentMy
                    .hideNavigationBar()
            }
            
        }
    }
    var contentMy: some View{
        GeometryReader { geometry in
        VStack{
            
            VStack{
            Spacer()
                .frame(height: 20)
                
            HStack{
                
                    Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                            .frame(width: 40)
                            .padding(.trailing, 10)
                            .onTapGesture {
                                withViewController.dismiss(animated: true, completion: nil)
                            }
                
                    Text("Contact Us").foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                
                    Spacer()
                            .frame(width: 40)
                            .padding(.leading, 10)
                                    
                }
            }
                .frame(width: geometry.size.width, height: 62, alignment: .center)
                .background(Color.init(hex: "922C3E"))
        
            ZendeskControllerWrapper(withViewController: withViewController)
                .frame(maxHeight: .infinity)
                .allowsHitTesting(true)
        }
        }.onAppear{
            
        }.onDisappear{
            
        }
    }
}

@available(iOS 13.0.0, *)
struct ZendeskNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ZendeskNavigationView(with: UIViewController())
    }
}

struct ZendeskControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
//    let onNodeClick:((AVPlayer,ARData)->Void)
    let withViewController: UIViewController
    class Coordinator: NSObject,UINavigationControllerDelegate {
        
        var parent: ZendeskControllerWrapper

        init(_ parent: ZendeskControllerWrapper) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @available(iOS 13.0, *)
    func makeUIViewController(context: UIViewControllerRepresentableContext<ZendeskControllerWrapper>) -> UIViewController {
       
        return withViewController
    }
    

    @available(iOS 13.0, *)
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ZendeskControllerWrapper>) {
    }
}


