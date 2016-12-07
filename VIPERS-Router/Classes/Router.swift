//
//  Router.swift
//  Pods
//
//  Created by Jan Bartel on 06.12.16.
//
//

import Foundation
import VIPERS_Router_Protocol
import VIPERS_Converter_Protocol


class RouterBlock<T> {
    let handler : T
    init (_ handler: T) {
        self.handler = handler
    }
}

open class Router : RouterProtocol{
    
    public init(){}
    
    fileprivate var routingConverters = [(id: String, converter: ConverterProtocol)]()
    fileprivate var routeDefinitionConverters = [ConverterProtocol]()
    fileprivate var routingHandlers = [String : Any]()
    
    open func addRouteDefinition<T : RouteDefinitionProtocol,R : RouteDescriptionProtocol>(_ routeDefinition : T, handler: @escaping (R) -> Void) throws{
        
        let uuid = try self.addDefinition(routeDefinition)
        
        let routerBlock = RouterBlock<(R) -> Void>(handler)
        
        self.routingHandlers[uuid] = routerBlock
        
    }
    
    open func addRouteDefinition<T : RouteDefinitionProtocol>(_ routeDefinition : T) throws{
        //if route definition is a valid converter add it, convert it to a converter else
        try self.addDefinition(routeDefinition)
    }
    
    
    open func addRouteDefinitionConverter<T : RouteDefinitionConverterProtocol> (_ converter : T) {
        self.routeDefinitionConverters.append(converter)
    }
    
    
    
    open func route<T : RouteDescriptionProtocol>(_ routeable : RouteableProtocol) throws -> T{
        let result : (route: T, id: String) = try self.routeWithIdOfConverter(routeable)
        return result.route
    }
    
    
    open func routeAndCallHandler<T : RouteDescriptionProtocol>(_ routeable : RouteableProtocol) throws -> T{
        let result : (route: T, id: String) = try self.routeWithIdOfConverter(routeable)
        
        let route = result.route
        let handlerId = result.id
        
        let handler = self.routingHandlers[handlerId]
        
        if handler != nil{
            let myHandler = handler! as! RouterBlock<(T) -> Void>
            myHandler.handler(route)
        }
        
        return route
    }
    
    
    //convert route and  memorize index of the converter used (nessecary for finding the right handler afterwards)
    func routeWithIdOfConverter<T : RouteDescriptionProtocol>(_ routeable : RouteableProtocol) throws -> (route: T,id: String){
        
        for converterTouple in routingConverters.reversed(){
            let routingConverter = converterTouple.converter
            if(routingConverter.isResponibleForOutputType(T)){
                
                let isResponsible = try routingConverter.isResponsible(routeable)
                
                if(isResponsible){
                    let route = try routingConverter.convert(routeable) as! T
                    return (route: route, id : converterTouple.id)
                }
            }
        }
        
        throw RouterErrorType.noRouteConverterForRouteableFound(routeable: routeable)
    }
    
    
    
    func addDefinition<T : RouteDefinitionProtocol>(_ routeDefinition : T) throws -> String{
        //if route definition is a valid converter add it, convert it to a converter else
        
        let uuid = UUID().uuidString
        
        if routeDefinition is ConverterProtocol {
            let touple = (id: uuid, converter: routeDefinition as! ConverterProtocol)
            self.routingConverters.append(touple)
        }else{
            
            var didAddConverter = false
            
            //convert definition here if non converter was given
            for routeDefinitionConverter in self.routeDefinitionConverters.reversed() {
                
                if(try routeDefinitionConverter.isResponsible(routeDefinition)){
                    var routingConverter = try routeDefinitionConverter.convert(routeDefinition)
                    
                    let touple = (id: uuid, converter: routingConverter as! ConverterProtocol)
                    
                    self.routingConverters.append(touple)
                    didAddConverter = true
                }
            }
            
            if(!didAddConverter){
                throw RouterErrorType.noRouteDefinitionConverterForRouteDefinitionFound(routeDefinition: routeDefinition)
            }
            
        }
        return uuid
    }
}
