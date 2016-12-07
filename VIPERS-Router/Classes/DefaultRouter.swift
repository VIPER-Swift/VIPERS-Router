//
//  DefaultRouter.swift
//  Pods
//
//  Created by Jan Bartel on 07.12.16.
//
//

import Foundation

public class DefaultRouter : Router{
    
    public override init(){
        super.init()
        let routeDefinitionConverter = StringRouteDefinitionConverter()
        self.addRouteDefinitionConverter(routeDefinitionConverter)
    }

}
