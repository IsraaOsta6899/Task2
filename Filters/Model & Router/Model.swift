//
//  Model.swift
//  Filters
//
//  Created by Israa Usta on 23/12/2022.
//

import Foundation
import Alamofire
class FiltersModel{
//    static var data: String {
//        get{
//            return "data"
//        }
//    }
    enum Keys: String{
        case data
    }
    
    /**
     Get all countries
     - Parameter CompletionHandler: Result<[Filters],NSError>
     */
    class func getFilters(CompletionHandler:@escaping(Result<[String:FilterCategory],NSError>)->Void) {
        var allFilters : [String:FilterCategory] = [:]
        AF.request(FilterRouter.allFilters).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    if let data = JSON[Keys.data.rawValue] {
                        if let json2 = data as? [String: Any]{
                            for value in json2 {
                                let filterCategory = json2[value.key] as? [String : Any] ?? [:]
                                let filter = FilterCategory(dict: filterCategory)
                                allFilters[value.key] = filter

                            }
                            CompletionHandler(.success(allFilters))
                        }
                    }
                }
                
            case .failure(_):
                CompletionHandler(.failure(NSError()))
            }
            
        }
        
    }
    
    func func1(completion: @escaping ()->Bool){
        func2{
            true
        }
    }
    
    func func2(completion: @escaping ()->Bool){
        
    }
    
}
