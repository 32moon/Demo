//
//  Contact.swift
//  Demo_Alamofire
//
//  Created by 이문정 on 2021/06/03.
//

import Foundation

struct APIResponse: Codable {
    let contacts: [Contact]
}

struct Contact: Codable {
    
    let name: String
    let email: String
    let gender: String
}
