//
//  ArchiveDetail.swift
//  Munecting_iOS
//
//  Created by seohuibaek on 2023/08/22.
//

import Foundation

struct ArchiveDetail: Codable {
    let name: String
    let artist: String
    let createAt: String
    let coverImg: String
    let writing: String
}

class ArchiveDetailManager {
    static let shared = ArchiveDetailManager() // 싱글톤 인스턴스
    
    var archiveDetail: ArchiveDetail?
    
    private init() { } // 외부에서 인스턴스 생성 방지
}
