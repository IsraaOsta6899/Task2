//
//  Model.swift
//  Filters
//
//  Created by Israa Usta on 23/12/2022.
//

import Foundation
import Alamofire
class FiltersModel{
    
    /**
     Get all countries
     - Parameter CompletionHandler: Result<[Filters],NSError>
     */
    class func getFilters(CompletionHandler:@escaping(Result<[Filters],NSError>)->Void) {
        var allFilters : [Filters] = []
        AF.request(FilterRouter.allFilters).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    if let data = JSON["data"] {
                        if let json2 = data as? [String: Any]{
                            let Classifications = json2["HECS"] as? [String : Any] ?? [:]
                            let classificationsFilters = Filters(dict: Classifications)
                            allFilters.append(classificationsFilters)
                            let cusine = json2["cusine"] as? [String : Any] ?? [:]
                            let cusineFilters = Filters(dict: cusine)
                            allFilters.append(cusineFilters)
                            let positions = json2["positions"] as? [String : Any] ?? [:]
                            let positionsFilters = Filters(dict: positions)
                            allFilters.append(positionsFilters)
                            let skills = json2["skills"] as? [String : Any] ?? [:]
                            let skillsFilters = Filters(dict: skills)
                            allFilters.append(skillsFilters)
                            CompletionHandler(.success(allFilters))
                        }
                    }
                }
                
            case .failure(_):
                CompletionHandler(.failure(NSError()))
            }
            
        }
        
    }
    
}
