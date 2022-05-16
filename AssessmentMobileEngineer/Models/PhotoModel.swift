//
//  UnsplashDataModel.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation

struct PhotoModel: Identifiable, Decodable {
    let id: String?
    let created_at: String?
    let updated_at: String?
    let promoted_at: String?
    let width: Int?
    let height: Int?
    let color: String?
    let blur_hash: String?
    let description: String?
    let alt_description: String?
    let urls: UrlObject?
    let links: LinkObject?
    let categories: [UrlObject]?
    let likes: Int?
    let liked_by_user: Bool?
    let current_user_collections: [UrlObject]?
    let sponsorship: UrlObject?
    let topic_submissions: UrlObject?
    let user: UrlObject?
}

struct UrlObject: Decodable {
    var id : UUID?
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let small_s3: String?
}

struct LinkObject: Decodable {
    let id: UUID?
    let `self`: String?
    let html: String?
    let download: String?
    let download_location: String?
}
