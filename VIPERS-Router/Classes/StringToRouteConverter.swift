//
//  StringToRoutingConverter.swift
//  Pods
//
//  Created by Jan Bartel on 14.04.16.
//
//

import Foundation
import VIPERS_Router_Protocol

extension String : RouteableProtocol{}

/**
 * A converter class that takes a route definition as a string (e.g.: "/testRoute/:id")
 * and converts a String as routable (e.g. "/testRoute/25") to a default route object
 **/
open class StringToRouteConverter : RouteConverterProtocol{
    
    public typealias RoutableType = String
    public typealias RouteType = DefaultRoute
    public typealias RouteDefinitionType = String
    
    let routeDefinition : String
    let isResponsibleRegex : NSRegularExpression
    
    public required init(routeDefinition : RouteDefinitionType){
        self.routeDefinition = routeDefinition
        
        let regex = try! NSRegularExpression(pattern: "(:[^/]+)", options: .caseInsensitive)
        
        let pattern = regex.stringByReplacingMatches(in: self.routeDefinition, options: .withoutAnchoringBounds, range: NSRange(location:0,length:self.routeDefinition.characters.count), withTemplate: "[^/]+")
        
        self.isResponsibleRegex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    
    }
    
    public typealias ConverterInputType  = String
    public typealias ConverterOutputType = DefaultRoute
    
    
    
    open func isResponsible(_ input: String) throws -> Bool {
        if(input is String){
    
            let matches = self.isResponsibleRegex.matches(in: input, options: .withoutAnchoringBounds, range: NSRange(location:0,length:input.characters.count))
            
            if(matches.count > 0){
                return true
            }
            
        }
        
        return false
    }
    
    open func convert(_ input: String) throws -> DefaultRoute{
        let params = try self.extractParams(input)
        let route = DefaultRoute(identifier: input, parameters: params)
        return route
    }
    
    open func extractParams(_ route : String) throws -> [String : Any]{
        var params = [String : Any]()
        
        let routeDefinitionParts = routeDefinition.components(separatedBy: "/")
        let routeParts = route.components(separatedBy: "/")
        
        for index in 0 ... routeDefinitionParts.count-1{
            
            if(routeDefinitionParts.count <= index || routeParts.count <= index){
                break
            }
            
            let definitionPart : String = routeDefinitionParts[index]
            let routePart : String = routeParts[index]
            
            // search for :param parameters in match
            let regex = try NSRegularExpression(pattern: "^:((.)+)$", options: .caseInsensitive)
            
            let matches = regex.matches(in: definitionPart, options: .withoutAnchoringBounds, range: NSRange(location:0,
                length:definitionPart.characters.count))
            
            if(matches.count > 0){
                let match = matches[0]
                let rangeWithOutDots = NSMakeRange(match.range.location + 1, match.range.length - 1)
                let range = self.range(definitionPart,nsRange: rangeWithOutDots)
                let matchedString = definitionPart.substring(with: range!)
                params[matchedString] = routePart
            }
        }
        
        return params
    }
    
    func nsRange(_ string: String,range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: string.utf16)
        let to = range.upperBound.samePosition(in: string.utf16)
        return NSRange(location: string.utf16.distance(from: string.utf16.startIndex, to: from),
                       length: string.utf16.distance(from: from, to: to))
    }
    
    func range(_ string: String,nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = string.utf16.index(string.utf16.startIndex, offsetBy: nsRange.location, limitedBy: string.utf16.endIndex),
            let to16 = string.utf16.index(from16, offsetBy: nsRange.length, limitedBy: string.utf16.endIndex),
            let from = String.Index(from16, within: string),
            let to = String.Index(to16, within: string)
            else { return nil }
        return from ..< to
    }
  
}


