import RxNetworkApiClient

class ExtendedApiRequest<T: Codable>: ApiRequest<T> {

    override var request: URLRequest {
        var result = super.request
        result.timeoutInterval = self.responseTimeout
        return result
    }
    
    override public init(_ endpoint: ApiEndpoint) {
        super.init(endpoint)
        
        super.responseTimeout = 30
    }
    
    public static func extendedRequest<T: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            query: QueryField...) -> ExtendedApiRequest<T> {
        
        ExtendedApiRequest
                    .extendedRequest(
                        path: path,
                        method: method,
                        endpoint: endpoint,
                        headers: headers,
                        formData: formData,
                        files: files,
                        body: body,
                        queryArr: query)
    }
    
    public static func extendedRequest<T: Codable>(
            path: String? = nil,
            method: HttpMethod,
            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
            headers: [Header]? = nil,
            formData: FormDataFields? = nil,
            files: [UploadFile]? = nil,
            body: BodyConvertible? = nil,
            queryArr: [QueryField]) -> ExtendedApiRequest<T> {
        
        let request = ExtendedApiRequest<T>(endpoint)
        request.path = path
        request.method = method
        request.headers = headers
        request.formData = formData
        request.files = files
        request.body = body
        request.query = queryArr
        return request
    }
}

fileprivate extension Data {
    
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8, allowLossyConversion: false) {
            self.append(data)
        }
    }
}

fileprivate extension Array where Element == QueryField {
    
    func toString() -> String {
        var allowedSymbols = CharacterSet.alphanumerics
        allowedSymbols.insert(charactersIn: "-._~&=") // as per RFC 3986
        allowedSymbols.remove("+")
        
        if !self.isEmpty,
           let flatStringQuery = self
            .compactMap({ queryField in
                guard let fieldValue = queryField.1, !fieldValue.isEmpty else {
                    return nil
                }
                return "\(queryField.0)=\(fieldValue)"
            })
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: allowedSymbols) {
            return "?\(flatStringQuery)"
        }
        return ""
    }
}
