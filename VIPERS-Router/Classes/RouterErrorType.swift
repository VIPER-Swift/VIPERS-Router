//
//  RouterErrorType.swift
//  Pods
//
//  Created by Jan Bartel on 06.12.16.
//
//

import Foundation
import VIPERS_Router_Protocol

public enum RouterErrorType : Error{
    case noRouteDefinitionConverterForRouteDefinitionFound(routeDefinition: RouteDefinitionProtocol)
    case noRouteConverterForRouteableFound(routeable: RouteableProtocol)
}
