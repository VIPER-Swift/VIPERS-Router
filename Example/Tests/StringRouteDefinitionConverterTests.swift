//
//  StringRouteDefinitionConverterTests.swift
//  VIPERS-Router
//
//  Created by Jan Bartel on 06.12.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import VIPERS_Router

class StringRouteDefinitionConverterTests: XCTestCase {
    
    func testIsResponsibleForString() {
        
        do{
        
            let converter = StringRouteDefinitionConverter()
            
            let testRouteDefinition = "/this/is/a/nice/:routedefinition"
            
            let responsible = try converter.isResponsible(testRouteDefinition)
            XCTAssertTrue(responsible)
        }catch _ {
            XCTFail("An error is not acceptable for this test")
        }
    }
    
    func testIsNotResponsibleForDate() {
        
        do{
            
            let converter = StringRouteDefinitionConverter()
            
            let testRouteDefinition = Date()
            
            let responsible = try converter.isResponsible(testRouteDefinition)
            XCTAssertFalse(responsible)
            
        }catch _ {
            XCTFail("An error is not acceptable for this test")
        }

        
    }
    
    func testCanCreateRouteConverterForString(){
        
        do{
            
            let converter = StringRouteDefinitionConverter()
            
            let testRouteDefinition = "/this/is/a/nice/:routedefinition"
            
            let routeConverter = try converter.convert(testRouteDefinition)
            XCTAssertNotNil(routeConverter)
            XCTAssertTrue(routeConverter is StringToRouteConverter, "resulting route converter shoul be a StringToRouteConverter")
            
        }catch _ {
            XCTFail("An error is not acceptable for this test")
        }
        
    }
    
}
