import Foundation
import RxNetworkApiClient
import CFNetwork

/// Русифицирует коды ошибок, которые могут вернуться от внутренней ошибки сети.
class NSErrorResponseHandler: ResponseHandler {

    public init() {
    }

    public func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                                   request: ApiRequest<T>,
                                   response: NetworkResponse) -> Bool {
        if let error = (response.error as NSError?) {
            let errorResponseEntity = ResponseErrorEntity(response.urlResponse)
            let errorDesc = error.code == -1_001
            ? error.localizedDescription + "\n"
            : error.localizedDescription
            errorResponseEntity.errors.append(errorDesc)
            observer(.error(errorResponseEntity))
            return true
        }
        return false
    }
}
