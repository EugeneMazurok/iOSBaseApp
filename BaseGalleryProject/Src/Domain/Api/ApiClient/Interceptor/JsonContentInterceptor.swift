//
// Created by admin on 2019-05-28.
// Copyright (c) 2019 WebAnt. All rights reserved.
//

import RxNetworkApiClient

class JsonContentInterceptor: Interceptor {

    func prepare<T: Codable>(request: ApiRequest<T>) {
        var headers = request.headers ?? [Header]()

        if !headers.contains(.acceptJson) {
            headers.append(.acceptJson)
            request.headers = headers
        }
    }

    func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        // Noting to do.
    }
}

class ExtraPathInterceptor: Interceptor {
    
    func prepare<T: Codable>(request: ApiRequest<T>) {

        if request.path?.contains("oauth") ?? false &&
            request.path?.contains("uploads") ?? false &&
            request.path?.contains("/api") ?? false &&
            request.path?.contains("/lookup") ?? false {
            request.path = Config.extraPath + (request.path ?? "")
        }
    }

    func handle<T: Codable>(request: ApiRequest<T>, response: NetworkResponse) {
        // Noting to do.
    }
}
