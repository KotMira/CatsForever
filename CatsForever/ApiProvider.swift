//
//  ApiProvider.swift
//  CatsForever
//
//  Created by Пользователь on 31.03.2021.
//

import Moya

let ApiProvider = MoyaProvider<Api>()
enum Api {
    case getImage
}

extension Api: TargetType {
    var baseURL: URL { URL(string: "https://aws.random.cat/")! }
    
    var path: String {
        switch self {
        case .getImage:
            return "meow"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data(count: 0)
    }
    
    var task: Task {
        switch self {
        case .getImage:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

