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

@available(iOS 14.0, *)
let coloredNavAppearance = UINavigationBarAppearance()

@available(iOS 14.0, *)
struct ZendeskNavigationView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var withViewController: UIViewController
    var toolbarColor: Color
    var toolbarName:String
    
    init(with _withViewController:UIViewController, toolbarHashColor _toolbarHashColor:String, toolbarName _toolbarName:String ) {
        //MARK: zendesk didn't change tabbar style by default
        //        coloredNavAppearance.configureWithOpaqueBackground()
        //        coloredNavAppearance.backgroundColor = .red
        //        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        //        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        //
        //        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        //        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        withViewController =  _withViewController
        toolbarName = _toolbarName
        toolbarColor = Color.init(hex: _toolbarHashColor)
    }
    
    @available(iOS 14.0, *)
    var body: some View {
        toolbarColor
            .edgesIgnoringSafeArea(.top)
            .overlay(
                content
                    .hideNavigationBar()
            )
    }
    
    var content: some View{
        GeometryReader { geometry in
            VStack{
                
                VStack{
                    Spacer()
                        .frame(height: 25)
                    
                    HStack{
                        
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                        //MARK: should be refactored
                            .foregroundColor(toolbarColor)
                            .colorInvert()
                            .frame(width: 15)
                            .padding(.leading, 15)
                            .onTapGesture {
                                withViewController.dismiss(animated: false, completion: nil)
                            }
                        
                        Text(toolbarName)
                        //MARK: should be refactored
                            .foregroundColor(toolbarColor)
                            .colorInvert()
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                            .frame(width: 15)
                            .padding(.trailing, 15)
                        
                    }
                    Spacer()
                        .frame(height: 5)
                }
                .frame(width: geometry.size.width, height: 50, alignment: .top)
                .background(toolbarColor)
                
                
                ZendeskControllerWrapper(withViewController: withViewController)
                    .ignoresSafeArea(.keyboard)
                    .frame(height: .infinity)
                    .allowsHitTesting(true)
                
            }
        }.onAppear{
            
        }.onDisappear{
            
        }
    }
}

@available(iOS 14.0, *)
struct ZendeskNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ZendeskNavigationView(with: UIViewController(), toolbarHashColor: "", toolbarName: "")
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


