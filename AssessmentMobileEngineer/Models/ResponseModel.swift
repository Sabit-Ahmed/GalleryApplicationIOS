//
//  UnsplashDataModel.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 16/5/22.
//

import Foundation

struct ResponseModel: Identifiable, Codable {
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
    var categories: [String]?
    let likes: Int?
    let liked_by_user: Bool?
    let current_user_collections: [String]?
    let sponsorship: SponsorshipObject?
    let topic_submissions: TopicSubmissionsObject?
    let user: SponsorObject?
}

struct UrlObject: Identifiable, Codable {
    var id : UUID?
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let small_s3: String?
}

struct LinkObject: Identifiable, Codable {
    let id: UUID?
    let `self`: String?
    let html: String?
    let download: String?
    let download_location: String?
}

struct SponsorshipObject: Identifiable, Codable {
    let id: UUID?
    let impression_urls: [String]?
    let tagline: String?
    let tagline_url: String?
    let sponsor: SponsorObject?
}

struct SponsorObject: Identifiable, Codable {
    let id: String?
    let updated_at: String?
    let username: String?
    let name: String?
    let first_name: String?
    let last_name: String?
    let twitter_username: String?
    let portfolio_url: String?
    let bio: String?
    let location: String?
    let links: SponsorLinkObject?
    let profile_image: ProfileImageObject?
    let instagram_username: String?
    let total_collections: Int?
    let total_likes: Int?
    let total_photos: Int?
    let accepted_tos: Bool?
    let for_hire: Bool?
    let social: SocialObject?
}

struct SponsorLinkObject: Identifiable, Codable {
    let id: UUID?
    let `self`: String?
    let html: String?
    let photos: String
    let likes: String
    let portfolio: String
    let following: String
    let followers: String
}

struct ProfileImageObject: Identifiable, Codable {
    let id: UUID?
    let small: String?
    let medium: String?
    let large: String?
}

struct SocialObject: Identifiable, Codable {
    let id: UUID?
    let instagram_username: String?
    let portfolio_url: String?
    let twitter_username: String?
    let paypal_email: String?
}

struct TopicSubmissionsObject: Identifiable, Codable {
    let id: UUID?
}
