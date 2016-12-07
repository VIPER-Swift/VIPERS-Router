//
//  StringToRouteConverterTests.swift
//  VIPERS-Router
//
//  Created by Jan Bartel on 06.12.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import VIPERS_Router

class StringToRouteConverterTests: XCTestCase {
    
    
    func testConversionWithMatchingString() {
        
        do{
        
            let routeDefinition = "/testRoute/:identifier"
            let routable = "/testRoute/256"
            
            let converter = StringToRouteConverter(routeDefinition: routeDefinition)
            
            let isResponsible = try converter.isResponsible(routable)
            XCTAssertTrue(isResponsible, "Converter should be responsible for this route")
            
            let route = try converter.convert(routable)
            XCTAssertNotNil(route)
            XCTAssertEqual(route.parameters["identifier"] as! String, "256")
            
        }catch _ {
            XCTFail("An error is not acceptable for this conversion")
        }
        
    }
    
    func testIsNotResponsibleForNonMatchingString() {
        
        do{
            
            let routeDefinition = "/testRoute/:identifier"
            let routable = "/this/routable/should/not/match"
            
            let converter = StringToRouteConverter(routeDefinition: routeDefinition)
            
            let isResponsible = try converter.isResponsible(routable)
            XCTAssertFalse(isResponsible, "Converter should be responsible for this route")
            
        }catch _ {
            XCTFail("An error is not acceptable for this conversion")
        }

    }
    
    
}
