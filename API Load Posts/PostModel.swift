//
//  PostModel.swift
//  TestApp
//
//  Created by Bishalw on 12/19/22.
//

import Foundation

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
