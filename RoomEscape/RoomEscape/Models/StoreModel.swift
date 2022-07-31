//
//  RoomModel.swift
//  RoomEscape
//
//  Created by Noah's Ark on 2022/07/18.
//

import Foundation

struct RoomModel: Codable, Hashable {
    let id: Int
    let location: String
    let storeName: String
    let address: String
    let phoneNumber: String
    let homepage: String
    let image: String
    let title: String
    let genre: String
    let difficulty: Int
    let activity: Int
    let horror: Int
    let description: String
    let recommendation: String
}
