import DITranquillity
import RxNetworkApiClient

class DI {
    
    private static let shared = DI()
    
    fileprivate(set) static var container = DIContainer()
    fileprivate(set) static var backgroundContainer = DIContainer()
    
    private init() {
        // No Constructor
    }

//     swiftlint:disable all
    /// Основные зависимости
    static func initDependencies(_ appDelegate: AppDelegate) {
        
        DI.container = DIContainer(parent: backgroundContainer)
        
        ApiEndpoint.baseEndpoint = ApiEndpoint.webAntDevApi
        
        self.container.register(AuthInterceptor.init)
            .as(AuthInterceptor.self)
            .lifetime(.single)
        
        self.container.register { () -> ApiClientImp in
            
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 60 * 20
            config.timeoutIntervalForResource = 60 * 20
            config.waitsForConnectivity = true
            config.shouldUseExtendedBackgroundIdleMode = true
            config.urlCache?.removeAllCachedResponses()
            
            let client = ApiClientImp(urlSessionConfiguration: config, completionHandlerQueue: .main)
            client.responseHandlersQueue.append(ErrorResponseHandler())
            client.responseHandlersQueue.append(JsonResponseHandler())
            client.responseHandlersQueue.append(NSErrorResponseHandler())
            
            client.interceptors.append(JsonContentInterceptor())
            client.interceptors.append(ExtraPathInterceptor())
            return client
        }
        .as(ApiClient.self)
        .injection(cycle: true) {
            $0.interceptors.insert($1 as AuthInterceptor, at: 0)
        }
        .lifetime(.single)
        
        // MARK: - Gateways
        
//        self.container.register(ApiAuthenticationGateway.init)
//            .as(AuthenticationGateway.self)
//            .lifetime(.single)
        
        // MARK: - UseCases
        
//        self.container.register(AuthUseCaseImp.init)
//            .as(AuthUseCase.self)
    }
    // swiftlint:enable all

    static func resolve<T>() -> T {
        self.container.resolve()
    }
    
    static func resolveBackground<T>() -> T {
        self.backgroundContainer.resolve()
    }
}
