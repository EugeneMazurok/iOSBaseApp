import Foundation
import RxNetworkApiClient
import RxSwift

extension ExtendedApiRequest {
    
    // MARK: - Auth
    
    static func tokenRefreshRequest(_ refreshToken: String) -> ExtendedApiRequest {
        extendedRequest(path: "/oauth/v2/token",
                        method: .post,
                        formData: [
                            "client_id": Config.clientId,
                            "client_secret": Config.clientSecret,
                            "grant_type": "refresh_token",
                            "refresh_token": refreshToken
                        ])
    }
    
    // MARK: - UserInfo
    
    static func getAccountRequest() -> ExtendedApiRequest {
        extendedRequest(path: "/users/current", method: .get)
    }
}
