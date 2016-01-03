//
//  ResultResult.swift
//  Lexico
//
//  Created by Victor Guerra on 02/01/16.
//  Copyright © 2016 Victor Guerra. All rights reserved.
//

// Given that Alamofire and Result frameworks define each a Result enum
// and that there is still a bug in swift where one can not use fully
// qualified names for types named as the module, we provide this hack
// for being able to using both frameworks in the same swift file. 

// Borrowed idea from: https://github.com/antitypical/Result/issues/77

import Foundation
import Result

struct RResult<T, Error: ErrorType> {
    typealias t = Result<T, Error>
}