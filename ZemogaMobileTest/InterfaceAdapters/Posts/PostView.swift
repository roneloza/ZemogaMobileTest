//
//  PostView.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 12/05/22.
//

import SwiftUI
import Combine

struct PostView: View {
    
    @ObservedObject var controller: PostController
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.white)
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Picker("", selection: self.$controller.selectedSegmented) {
                        Text("All").tag(0)
                        Text("Favorites").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(8)
                ZStack {
                    VStack(spacing: 0) {
                        List {
                            ForEach(self.controller.selectedSegmented == 0 ?
                                    self.controller.all :
                                        self.controller.favorites) { post in
                                NavigationLink {
                                    PostDetailView(post: post,
                                                   controller: self.controller)
                                } label: {
                                    ZStack {
                                        HStack(spacing: 8) {
                                            if post.isFavorite {
                                                Image(systemName: "star.fill").foregroundColor(.yellow)
                                            } else {
                                                Image(systemName: "circle.fill").foregroundColor(.blue)
                                            }
                                            Text(post.title)
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .listRowBackground(Color.white)
                        }
                        .listStyle(.plain)
                    }
                }
            }
            if self.controller.fetchPostsStatus == .loading {
                ProgressView("loading")
            }
        }
        .background(.green)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Posts", displayMode: .inline)
        .toolbar {
            HStack {
                Button(action: {
                    self.controller.interactor.removePosts()
                }, label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }).tag("button-remove")
                Button(action: {
                    self.controller.interactor.fetchPosts()
                }, label: {
                    Image(systemName: "arrow.clockwise").foregroundColor(.white)
                }).tag("button-refresh")
            }
        }
    }
    
    init(controller: PostController) {
        self.controller = controller
    }
}

#if DEBUG
struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            view:
                AnyView(
                    PostView(controller: PostController())))
    }
}
#endif
