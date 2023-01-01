//
//  Filter Router.swift
//  Filters
//
//  Created by Israa Usta on 23/12/2022.
//

import Foundation
import Alamofire
enum FilterRouter: URLRequestConvertible {
    
    // case all Filters to make request to get all Filters from API
    case allFilters
    
    // base url that exsist in all request in this router
    var baseURL: String {
        switch self {
        case .allFilters:
            return "https://gateway.harri.com"
        }
    }
    
    // ending path for each case
    var path: String {
        switch self {
        case .allFilters :
            return "/core/api/v1/public_job/getActiveFilters"
        }
        
    }
    
    // http methode for each case
    var method: HTTPMethod {
        switch self {
        case  .allFilters:
            return .get
        }
        
    }
    
    
    // method to return completed request
    func asURLRequest() throws -> URLRequest {
        
        let url = try baseURL.asURL().appendingPathComponent(path).absoluteString
        var request = URLRequest(url: URL(string: url)!)
        request.method = method
        return request
    }
}
