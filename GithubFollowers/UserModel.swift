//
//  UserModel.swift
//  GithubFollowers
//
//  Created by Shelly Gupta on 12/7/21.
//

import Foundation

struct UserModel: Codable {
    let login: String
    let avatar_url: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatar_url
    }
}

extension UserModel {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decode(String.self, forKey: .login)
        avatar_url = try values.decodeIfPresent(String.self, forKey: .avatar_url)
    }
}
