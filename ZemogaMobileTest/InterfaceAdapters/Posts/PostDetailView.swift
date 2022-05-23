//
//  PostDetailView.swift
//  ZemogaMobileTest
//
//  Created by Rone Shender Loza Aliaga on 19/05/22.
//

import SwiftUI

struct PostDetailView: View {
    
    @ObservedObject var post: PostModel
    private(set) weak var controller: PostController?
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.white)
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Description")
                            .font(.system(size: 24, weight: .bold))
                        Text(self.post.description)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("User")
                            .font(.system(size: 24, weight: .bold))
                        Text(self.post.user.name)
                        Text(self.post.user.email)
                        Text(self.post.user.phone)
                        Text(self.post.user.website)
                    }
                    Spacer()
                }
                .padding(.all, 16)
                ZStack {
                    VStack {
                        List {
                            Section {
                                ForEach(self.post.comments) { comment in
                                    Text(comment.body)
                                }
                                .listRowBackground(Color.white)
                            } header: {
                                HStack {
                                    Text("COMMENTS")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                .background(Color.white)
                Spacer()
            }
            ProgressView("loading")
        }
        .onAppear(perform: {
            self.controller?.interactor.fetchUser(request: PostUserRequest(postId: self.post.id,
                                                                userId: self.post.userId))
            self.controller?.interactor.fetchComments(postId: self.post.id)
            self.controller?.currentPost = self.post
        })
        .background(.green)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(self.post.title)
        .toolbar {
            HStack {
                Button(action: {
                    _ = self.controller?.interactor.removePost(self.post)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                                case .finished:
                                    self.presentationMode.wrappedValue.dismiss()
                                default: break
                            }
                        }, receiveValue: { _ in }
                        )
                }, label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }).tag("button-remove")
                Button(action: {
                    self.post.isFavorite.toggle()
                    self.controller?.interactor.updatePost(self.post)
                }, label: {
                    Image(systemName: (self.post.isFavorite ? "star.fill" :"star"))
                        .foregroundColor(.yellow)
                }).tag("button-favorite")
            }
        }
    }
    
    init(post: PostModel,
         controller: PostController? = nil) {
        self.post = post
        self.controller = controller
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(view: AnyView(PostDetailView(post: PostModel(
            id: 1,
            userId: 1,
            title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            description: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
            user: UserModel(id: 1,
                            name: "Leanne Graham",
                            email: "Sincere@april.biz",
                            phone: "1-770-736-8031 x56442",
                            website: "hildegard.org"),
            comments: [CommentModel(id: 1,
                                    postId: 1,
                                    name: "id labore ex et quam laborum",
                                    email: "Eliseo@gardner.biz",
                                    body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")]
        ))))
    }
}
