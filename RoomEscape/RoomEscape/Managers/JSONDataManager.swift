//
//  JSONDataManager.swift
//  RoomEscape
//
//  Created by Noah's Ark on 2022/07/18.
//

import Foundation

class JSONDataManager: ObservableObject {
    @Published var roomData: [RoomModel] = []
    static let shared = JSONDataManager()

    init() {
        loadData()
    }
    
    private func loadData() {
        guard let path = Bundle.main.path(forResource: "StoreData", ofType: "json") else {
            print("1")
            return
        }
        guard let storeJSON = try? String(contentsOfFile: path) else {
            print("2")
            return
        }
        
        let decoder = JSONDecoder()
        let data = storeJSON.data(using: .utf8)
        
        guard let data = data,
              let response = try? decoder.decode([RoomModel].self, from: data) else {
            print("3")
            return
        }
        self.roomData = response
    }
    
}// JSONDataManager
