import UIKit
import XCTest
import VIPERS_Router_Protocol
import VIPERS_Router

class TestRoutingTests: XCTestCase {
    
    var router : Router!
    
    override func setUp() {
        super.setUp()
        self.setUpRouter()
        
    }
    
    func setUpRouter(){
        self.router = Router()
        
        let routeConverter = StringRouteDefinitionConverter()
        self.router.add(routeDefinitionConverter:routeConverter)
    }
    
    func testGetRouteWithCorrectRoutable() {
        
        do {
    
            var didCall = false
            
            try self.router.add(routeDefinition:"/testRoute/:id") { ( route : DefaultRoute ) in
                didCall = true
            }
            
            let route1 : DefaultRoute = try self.router.route("/testRoute/15")
            XCTAssertNotNil(route1)
            XCTAssertFalse(didCall,"The route method should not call any handler")
            XCTAssertEqual(route1.parameters["id"] as! String, "15")
            
        } catch let error {
            XCTFail(String(describing: error) )
        }

    }
    
    
    func testGetRouteWithCorrectRoutableAndMoreThanOneRouteDefinition() {
        
        do {
            
            var didCall1 = false
            
            try self.router.add(routeDefinition:"/testRoute/:id") { ( route : DefaultRoute ) in
                didCall1 = true
            }
            
            var didCall2 = false
            try self.router.add(routeDefinition:"/some/other/routable") { ( route : DefaultRoute ) in
                didCall2 = true
            }
            
            
            let route1 : DefaultRoute = try self.router.route("/testRoute/15")
            XCTAssertNotNil(route1)
            XCTAssertFalse(didCall1,"The route method should not call any handler")
            XCTAssertFalse(didCall2,"The route method should not call any handler")
            XCTAssertEqual(route1.parameters["id"] as! String, "15")
            
        } catch let error {
            XCTFail(String(describing: error) )
        }
        
    }

    
    
    func testDoNotGetRouteWithWrongRouteable() {
        
        do {
            
            var didCall = false
            
            try self.router.add(routeDefinition:"/testRoute/:id") { ( route : DefaultRoute ) in
                didCall = true
            }
            
            let route1 : DefaultRoute = try self.router.route("/This/Routable/Shouldnt/be/found")
            XCTAssertNil(route1)
            XCTAssertFalse(didCall,"The route method should not call any handler")

        } catch RouterErrorType.noRouteConverterForRouteableFound {
            XCTAssertTrue(true)
        } catch let error {
            XCTFail(String(describing: error))
        }
        
    }
    
    
    func testCallRouteHandlerForCorrectRoutable(){
        do {
            
            var didCall = false
            
            try self.router.add(routeDefinition:"/testRoute/:id") { ( route : DefaultRoute ) in
                didCall = true
            }
            
            let route1 : DefaultRoute = try self.router.routeAndCallHandler("/testRoute/15")
            XCTAssertNotNil(route1)
            XCTAssertTrue(didCall,"The routeAndCallHandler method should call the handler")
            XCTAssertEqual(route1.parameters["id"] as! String, "15")
            
        } catch let error {
            XCTFail(String(describing: error) )
        }
    }
    
    func testDoNotCallRouteHandlerForWrongRoutable(){
        
        var didCall = false
        
        do {
            
            try self.router.add(routeDefinition:"/testRoute/:id") { ( route : DefaultRoute ) in
                didCall = true
            }
            
            let _ : DefaultRoute = try self.router.routeAndCallHandler("/This/Routable/Shouldnt/be/found")
            XCTAssertTrue(false,"Since a wrong route was called, an exception should be thrown")
            
        } catch RouterErrorType.noRouteConverterForRouteableFound {
            XCTAssertFalse(didCall,"The routeAndCallHandler method should not call the handler")
            XCTAssertTrue(true)
        } catch let error {
            XCTFail(String(describing: error) )
        }
    }
    
}
