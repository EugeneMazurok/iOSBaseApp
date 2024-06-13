import Foundation
import RxNetworkApiClient
import RxSwift

/// Same as ApiClientImp but removed Rx timeout option.
///
/// It uses default URLRequest class timeout which throws localized NSError after timeout.
public class ApiClientImp: ApiClient {
    
    private let urlSession: URLSessionProtocol
    public var dispatchQueue = SerialDispatchQueueScheduler(qos: .default,
                                                            internalSerialQueueName: "network_queue")

    public var interceptors = [Interceptor]()
    /*
     При добавлением обработчиков в список важно учитывать
     порядок, в котором они будут вызываться.
     */
    public var responseHandlersQueue = [ResponseHandler]()

    public init(urlSessionConfiguration: URLSessionConfiguration,
                completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration,
                                delegate: nil,
                                delegateQueue: completionHandlerQueue)
    }

    public init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    public static func defaultInstance(host: String) -> ApiClientImp {
        ApiEndpoint.baseEndpoint = ApiEndpoint(host)
        let apiClient = ApiClientImp(urlSession: URLSession.shared)
        apiClient.interceptors.append(LoggingInterceptor())
        apiClient.responseHandlersQueue.append(JsonResponseHandler())
        return apiClient
    }

    public func execute<T>(request: ApiRequest<T>) -> Single<T> {
        Single.create { (observer: @escaping (SingleEvent<T>) -> Void) in
                    self.prepare(request)
                    let dataTask: URLSessionDataTask = self.urlSession
                            .dataTask(with: request.request) { data, response, error in

                        self.preHandle(request, (data, response, error))
                        var isHandled = false
                        for handler in self.responseHandlersQueue {
                            if isHandled {
                                break
                            }
                            isHandled = handler.handle(observer: observer,
                                                       request: request,
                                                       response: (data, response, error))
                        }
                        if !isHandled {
                            let errorEntity = ResponseErrorEntity(response)
                            errorEntity.errors.append(
                                    "Inner app error: can't find appropriate response handler.")
                            observer(.error(errorEntity))
                        }
                            }
                    dataTask.resume()
                    return Disposables.create {
                        dataTask.cancel()
                    }
        }
                .subscribeOn(dispatchQueue)
                .observeOn(dispatchQueue)
                .do(onError: { error in
                    print("network error:", error)
                })
    }

    /// Вызывается перед тем, как обработается ответ от сервера.
    ///
    /// - Parameter response: Полученный ответ.
    private func preHandle<T: Codable>(_ request: ApiRequest<T>, _ response: NetworkResponse) {
        interceptors.forEach { interceptor in
            interceptor.handle(request: request, response: response)
        }
    }

    /// Вызывается перед тем, как будет отправлен запрос к серверу.
    ///
    /// - Parameter request: Запрос, который отправляется.
    private func prepare<T>(_ request: ApiRequest<T>) {
        interceptors.forEach { interceptor in
            interceptor.prepare(request: request)
        }
    }
}
