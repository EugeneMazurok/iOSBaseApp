//
// Created by Unicorn on 2019-05-27.
// Copyright (c) 2019 WebAnt. All rights reserved.
//

import Foundation
import RxNetworkApiClient

/// Добавляет к каждому запросу заголовок авторизации, если есть токен авторизации.
class AuthInterceptor: Interceptor {

    private let settings: Settings

    init(_ settings: Settings) {
        self.settings = settings
    }
    
    func prepare<T: Codable>(request: ApiRequest<T>) {
        
        if !(request.path?.contains("oauth") ?? false) {
            let authHeaderKey = "Authorization"
            let index = request.headers?.firstIndex(where: { $0.key == authHeaderKey })
            if let auth = settings.token {
                let authHeader = Header(authHeaderKey, "Bearer \(auth.accessToken)")
                if let index = index {
                    request.headers?[index] = authHeader
                } else {
                    if request.headers == nil {
                        request.headers = [authHeader]
                    } else {
                        request.headers?.append(authHeader)
                    }
                }
            }
        }
    }
        
    func handle<T: Codable>(request: ApiRequest<T>,
                            response: NetworkResponse) {
        // empty
    }
}
