import RxSwift
import SwiftyJSON
import RxNetworkApiClient

/// Словарь заголовков ответов от сервера
public typealias ResponseHeaders = [AnyHashable: Any]?

/// Протокол для работы с заголовками в ответах на запросы
public protocol EntityWithHeaders {
    
    /// Заголовки
    var responseHeaders: ResponseHeaders? { get set }
}

/// Возвращает требуемый объект или JSON объект, если ответ успешный.
open class ExtendedJsonResponseHandler: ResponseHandler {
        
    private let decoder = JSONDecoder()
    
    public init() { }
    
    public func handle<T: Codable>(observer: @escaping SingleObserver<T>,
                                   request: ApiRequest<T>,
                                   response: NetworkResponse) -> Bool {
        if let data = response.data {
            do {
                if T.self == JSON.self {
                    let json = try JSON(data: data)
                    let castedResult: T = try self.castToResult(json)
                    observer(.success(castedResult))
                } else if T.self == Data.self {
                    let castedResult: T = try self.castToResult(data)
                    observer(.success(castedResult))
                } else if T.self == String.self {
                    let stringValue = String(data: data, encoding: String.Encoding.utf8)
                    let castedResult: T = try self.castToResult(stringValue)
                    observer(.success(castedResult))
                } else {
                    let result = try decoder.decode(T.self, from: data)
                    
                    guard let resultWithHeaders = result as? EntityWithHeaders else {
                        observer(.success(result))
                        return true
                    }
                    let response = response.urlResponse as? HTTPURLResponse
                    var finalResult = resultWithHeaders
                    finalResult.responseHeaders = response?.allHeaderFields
                    let castedResult: T = try self.castToResult(finalResult)
                    observer(.success(castedResult))
                }
            } catch {
                observer(.error(error))
            }
            return true
        }
        return false
    }
    
    func castToResult<T: Codable>(_ entity: Any?) throws -> T {
        guard let castedEntity = entity as? T else {
            throw DecodingError.typeMismatch(String.self,
                                             DecodingError.Context(codingPath: [],
                                                                   debugDescription: ""))
        }
        return castedEntity
    }
}
