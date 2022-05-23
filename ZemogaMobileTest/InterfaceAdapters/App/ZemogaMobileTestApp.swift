//
//  ZemogaMobileTestApp.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 11/05/22.
//

import SwiftUI
import UIKit

@main
struct ZemogaMobileTestApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                view:
                    AnyView(
                        PostView(
                            controller: PostController(
                                interactor:
                                    PostInteractor(
                                        dataTransferable: PostsDataTransferManager(
                                            PostsDataTransferFactory().get(.network))),
                                presenter: PostPresenter()))))
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                    UINavigationBar.appearance().tintColor = UIColor.white
                }
        }
    }
}
