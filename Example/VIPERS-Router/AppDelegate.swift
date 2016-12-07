//
//  AppDelegate.swift
//  VIPERS-Router
//
//  Created by Jan Bartel on 12/06/2016.
//  Copyright (c) 2016 Jan Bartel. All rights reserved.
//

import UIKit
import VIPERS_Converter_Protocol
import VIPERS_Router_Protocol
import VIPERS_Router


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let router = DefaultRouter()
        
        let routeDefinition : String = "/testRoute/:id"
        
        do {
            
            try router.add(routeDefinition: routeDefinition) { ( route : DefaultRoute ) in
                print("call \(route.identifier)")
            }
            
            let route1 : DefaultRoute = try router.routeAndCallHandler("/testRoute/15")
            print("route1: \(route1)")
            
        } catch let error {
            print(error)
        }
    
       
        
        return true
    }

}
