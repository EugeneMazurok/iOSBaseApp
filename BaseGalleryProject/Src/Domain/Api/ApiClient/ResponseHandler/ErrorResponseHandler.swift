import Foundation
import RxSwift
import RxNetworkApiClient

open class ErrorResponseHandler: ResponseHandler {
    
    private let jsonDecoder = JSONDecoder()

    public func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                                   request: ApiRequest<T>,
                                   response: NetworkResponse) -> Bool {
        guard let urlResponse = response.urlResponse,
            let nsHttpUrlResponse = urlResponse as? HTTPURLResponse else {
                return false
        }
        if let host = nsHttpUrlResponse.url?.host {
            let errorEntity = ResponseErrorEntity(response.urlResponse)
            
            switch nsHttpUrlResponse.statusCode {
            case 408:

                return true

            case 500:
                return true

            case 502:
                return true

            case 503:
                return true

            case 504:
                return true

            case 404:
                // When performing a resumable upload, handle 404 Not Found errors
                //  by starting the entire upload over from the beginning.
                                
                errorEntity.errors.append(R.string.responseHandlers.notFound())
                observer(.error(errorEntity))
                return true

            default:
                break
            }
            
            return false
        } else if (300..<600).contains(nsHttpUrlResponse.statusCode) {
            let errorEntity = ResponseErrorEntity(response.urlResponse)

            if let data = response.data {

                #if DEBUG
                // swiftlint:disable cyrillic_strings
                var debugDescription = [String]()
                debugDescription.append("|| \(nsHttpUrlResponse.statusCode) ||\n")
                switch nsHttpUrlResponse.statusCode {
                case (300..<400):
                    debugDescription.append("Неверный редирект.\n")

                case (400..<500):
                    debugDescription.append("Неверный запрос.\n")

                case (500..<600):
                    debugDescription.append("Ошибка сервера.\n")

                default:
                    debugDescription.append("Неизвестная ошибка.\n")
                }
                errorEntity.errors.insert(contentsOf: debugDescription, at: 0)
                // swiftlint:enable cyrillic_strings
                #endif
            }

            observer(.error(errorEntity))
            return true
        }
        return false
    }
}
