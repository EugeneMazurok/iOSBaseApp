//
// Created by admin on 2019-05-28.
// Copyright (c) 2019 WebAnt. All rights reserved.
//

import RxNetworkApiClient

extension Header: Equatable {

    public static func == (lhs: Header, rhs: Header) -> Bool {
        lhs.key == rhs.key &&
               lhs.value == rhs.value
    }
}

extension Dictionary: BodyConvertible where Key: Codable, Value: Codable {
}

extension Dictionary: JsonBodyConvertible where Key: Codable, Value: Codable {
}
