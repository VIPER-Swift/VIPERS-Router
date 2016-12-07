//
//  StringRouteDefinitionConverter.swift
//  Pods
//
//  Created by Jan Bartel on 17.04.16.
//
//

import Foundation
import VIPERS_Router_Protocol

extension String : RouteDefinitionProtocol{}

open class StringRouteDefinitionConverter : RouteDefinitionConverterProtocol{
    
    public typealias RouteDefinitionType = String
    public typealias RouteConverterType  = StringToRouteConverter
    
    public init(){}
    
    open func isResponsible(_ input: String) -> Bool {
        return input is String
    }
    
    open func convert(_ input: String) throws -> StringToRouteConverter {
        let routeConverter = StringToRouteConverter(routeDefinition : input )
        return routeConverter 
    }
    
}
