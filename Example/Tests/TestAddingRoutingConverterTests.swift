//
//  TestAddingRoutingConverterTests.swift
//  VIPERS-Router
//
//  Created by Jan Bartel on 06.12.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import VIPERS_Router_Protocol
import VIPERS_Router

class TestAddingRoutingConverterTests: XCTestCase {
    
    func testAddStringRouteDefinitionConverter() {
        let router = Router()
        
        let routeConverter = StringRouteDefinitionConverter()
        router.add(routeDefinitionConverter:routeConverter)
        
        do {
            try router.add(routeDefinition:"/this/is/a/nice/route/definition")
        } catch _ {
            XCTFail("We added a string route definition converter, but we can't add a string as route definition without a failure ")
        }
        
        do {
            let route : DefaultRoute = try router.route("/this/is/a/nice/route/definition")
            XCTAssertEqual(route.identifier, "/this/is/a/nice/route/definition")
            
        } catch _ {
            XCTFail("We added a string route definition converter, and added a string route definition, but we can't route to it ")
        }
        
    }
    
    
    
}
