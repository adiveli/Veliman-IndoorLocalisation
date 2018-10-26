//
//  MatrixSolver.swift
//  IndoorLocalisation
//
//  Created by Adi Veliman on 15/04/2018.
//  Copyright © 2018 Adi Veliman. All rights reserved.
//

import Foundation


import Foundation
import Accelerate.vecLib.LinearAlgebra


class MatrixSolver{
    
    
    func solve(A: [Double], b: [Double]) -> [Double]{
        let matA = la_matrix_from_double_buffer(A, 2, 2, 2, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        let vecB = la_matrix_from_double_buffer(b, 2, 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        
        let vecCj = la_solve(matA, vecB)
        var cj: [Double] = Array(repeating: 0.0, count: 2)
        
        let status = la_matrix_to_double_buffer(&cj, 1, vecCj)
        if status == la_status_t(LA_SUCCESS) {
            print(cj)
        } else {
            print("Failure: \(status)")
        }
        return cj
    }
}
