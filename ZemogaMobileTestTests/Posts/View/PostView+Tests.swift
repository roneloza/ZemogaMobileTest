//
//  PostView+Tests.swift
//  ZemogaMobileTestTests
//
//  Created by Rone Shender Loza Aliaga on 18/05/22.
//

import XCTest
import ViewInspector
@testable import ZemogaMobileTest

extension PostView: Inspectable {}

class PostControllerExpectationStub: PostController {
    
    let exp: XCTestExpectation
    
    init(interactor: PostUseCaseInput,
         presenter: PostUseCaseOutput,
         _ exp: XCTestExpectation) {
        self.exp = exp
        super.init(interactor: interactor, presenter: presenter)
    }
    
    override var posts: [PostModel] {
        willSet {
            self.exp.fulfill()
        }
    }
}
