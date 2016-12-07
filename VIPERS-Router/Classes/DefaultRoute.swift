//
//  DefaultRoute.swift
//  Pods
//
//  Created by Jan Bartel on 14.04.16.
//
//

import Foundation
import VIPERS_Router_Protocol

public struct DefaultRoute : RouteDescriptionProtocol {
    
    public let identifier : String
    public let parameters : [String : Any]
    
    init(identifier: String, parameters : [String : Any]){
        self.identifier = identifier
        self.parameters = parameters
    }
    
}
