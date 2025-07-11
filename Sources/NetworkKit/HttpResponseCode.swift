//
//  HttpResponseCode.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

import Foundation

/// Represents various HTTP response status codes along with their descriptions.
public enum ResponseCode: Int, CaseIterable, Hashable, Equatable, Codable, Sendable, LocalizedError
{
    /// 100 Continue: The server has received the request headers and the client should proceed to send the request body.
    case continueRequest = 100
    /// 101 Switching Protocols: The server is switching protocols according to the client request.
    case switchingProtocols = 101
    /// 102 Processing: The server is processing the request, but no response is available yet.
    case processing = 102
    /// 200 OK: The request was successful and the server has returned the requested data.
    case ok = 200
    /// 201 Created: The request has been fulfilled, resulting in the creation of a new resource.
    case created = 201
    /// 202 Accepted: The request has been accepted for processing, but processing is not yet complete.
    case accepted = 202
    /// 203 Non-Authoritative Information: The returned meta-information in the entity-header is not the definitive set available from the origin server.
    case nonAuthoritativeInformation = 203
    /// 204 No Content: The server successfully processed the request, but there is no new information to send.
    case noContent = 204
    /// 205 Reset Content: The server has fulfilled the request and the user agent should reset the document view which caused the request to be sent.
    case resetContent = 205
    /// 206 Partial Content: The server has fulfilled the partial GET request for the resource.
    case partialContent = 206
    /// 207 Multi-Status: The response requires multiple responses to complete the request.
    case multiStatus = 207
    /// 208 Already Reported: The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again.
    case alreadyReported = 208
    /// 226 IM Used: The server has completed the request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.
    case imUsed = 226
    /// 300 Multiple Choices: The requested resource corresponds to any one of a set of representations.
    case multipleChoices = 300
    /// 301 Moved Permanently: The requested resource has been assigned a new permanent URI and any future references to this resource should use one of the returned URIs.
    case movedPermanently = 301
    /// 302 Found: The requested resource has been temporarily moved to the URL given by the Location header.
    case found = 302
    /// 303 See Other: The response to the request can be found under another URI using the GET method.
    case seeOther = 303
    /// 304 Not Modified: The requested resource has not been modified since the specified time.
    case notModified = 304
    /// 305 Use Proxy: The requested resource must be accessed through the proxy given by the Location field.
    case useProxy = 305
    /// 307 Temporary Redirect: The requested resource resides temporarily under a different URI.
    case temporaryRedirect = 307
    /// 308 Permanent Redirect: The requested resource has been permanently moved to the URL given by the Location header.
    case permanentRedirect = 308
    /// 400 Bad Request: The request could not be understood or was missing required parameters.
    case badRequest = 400
    /// 401 Unauthorized: The client must authenticate to get the requested response.
    case unauthorized = 401
    /// 402 Payment Required: The payment is required for the requested response.
    case paymentRequired = 402
    /// 403 Forbidden: The client does not have permission to access the requested resource.
    case forbidden = 403
    /// 404 Not Found: The requested resource could not be found.
    case notFound = 404
    /// 405 Method Not Allowed: The method specified in the request is not allowed for the resource identified by the request URI.
    case methodNotAllowed = 405
    /// 406 Not Acceptable: The server cannot produce a response matching the list of acceptable values defined in the request's headers.
    case notAcceptable = 406
    /// 407 Proxy Authentication Required: The client must first authenticate itself with the proxy.
    case proxyAuthenticationRequired = 407
    /// 408 Request Timeout: The client did not produce a request within the time that the server was prepared to wait.
    case requestTimeout = 408
    /// 409 Conflict: The request could not be completed due to a conflict with the current state of the resource.
    case conflict = 409
    /// 410 Gone: The requested resource is no longer available at the server and no forwarding address is known.
    case gone = 410
    /// 411 Length Required: The server requires a content-length in the request.
    case lengthRequired = 411
    /// 412 Precondition Failed: The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server.
    case preconditionFailed = 412
    /// 413 Payload Too Large: The server is refusing to process a request because the request payload is larger than the server is willing or able to process.
    case payloadTooLarge = 413
    /// 414 URI Too Long: The server is refusing to service the request because the request-target is longer than the server is willing to interpret.
    case uriTooLong = 414
    /// 415 Unsupported Media Type: The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the method requested.
    case unsupportedMediaType = 415
    /// 416 Range Not Satisfiable: The client has asked for a portion of the file (byte serving), but the server cannot supply that portion.
    case rangeNotSatisfiable = 416
    /// 417 Expectation Failed: The expectation given in the request's Expect header field could not be met by the server.
    case expectationFailed = 417
    /// 418 I'm a Teapot: The HTCPCP server is a teapot that is not capable of brewing coffee.
    case imATeapot = 418
    /// 421 Misdirected Request: The request was directed at a server that is not able to produce a response.
    case misdirectedRequest = 421
    /// 422 Unprocessable Entity: The server understands the content type of the request entity, and the syntax of the request entity is correct, but it was unable to process the contained instructions.
    case unprocessableEntity = 422
    /// 423 Locked: The resource that is being accessed is locked.
    case locked = 423
    /// 424 Failed Dependency: The method could not be performed on the resource because the requested action depended on another action and that action failed.
    case failedDependency = 424
    /// 425 Too Early: The server is unwilling to risk processing a request that might be replayed.
    case tooEarly = 425
    /// 426 Upgrade Required: The client should switch to a different protocol such as TLS/1.0.
    case upgradeRequired = 426
    /// 428 Precondition Required: The origin server requires the request to be conditional.
    case preconditionRequired = 428
    /// 429 Too Many Requests: The user has sent too many requests in a given amount of time.
    case tooManyRequests = 429
    /// 431 Request Header Fields Too Large: The server is refusing to process the request because the request's headers are too large.
    case requestHeaderFieldsTooLarge = 431
    /// 451 Unavailable For Legal Reasons: The requested resource is unavailable for legal reasons.
    case unavailableForLegalReasons = 451
    /// 500 Internal Server Error: An error occurred on the server.
    case internalServerError = 500
    /// 501 Not Implemented: The server does not support the functionality required to fulfill the request.
    case notImplemented = 501
    /// 502 Bad Gateway: The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request.
    case badGateway = 502
    /// 503 Service Unavailable: The server is currently unable to handle the request due to temporary overloading or maintenance of the server.
    case serviceUnavailable = 503
    /// 504 Gateway Timeout: The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server or some other auxiliary server it needed to access in order to complete the request.
    case gatewayTimeout = 504
    /// 505 HTTP Version Not Supported: The server does not support the HTTP protocol version that was used in the request.
    case httpVersionNotSupported = 505
    /// 506 Variant Also Negotiates: The server has an internal configuration error: the chosen variant resource is configured to engage in transparent content negotiation itself, and is therefore not a proper end point in the negotiation process.
    case variantAlsoNegotiates = 506
    /// 507 Insufficient Storage: The method could not be performed on the resource because the server is unable to store the representation needed to successfully complete the request.
    case insufficientStorage = 507
    /// 508 Loop Detected: The server detected an infinite loop while processing the request.
    case loopDetected = 508
    /// 510 Not Extended: Further extensions to the request are required for the server to fulfill it.
    case notExtended = 510
    /// 511 Network Authentication Required: The client must authenticate itself to get network access.
    case networkAuthenticationRequired = 511
    /// 0 Unknown: An unknown error occurred.
    case unknown = 0

    /// Returns a ResponseCode instance based on the provided HTTP status code.
    /// - Parameter statusCode: The received HTTP status code.
    /// - Returns: A ResponseCode instance representing the provided status code.
    public static func from(statusCode: Int) -> ResponseCode {
        ResponseCode(rawValue: statusCode) ?? .unknown
    }

    public var errorDescription: String? {
        switch self {
        case .unknown:
            "An unknown error occurred."
        default:
            "The server returned an error with status code \(rawValue)."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .continueRequest:
            "The server has received the request headers and the client should proceed to send the request body."
        case .switchingProtocols:
            "The server is switching protocols according to the client request."
        case .processing:
            "The server is processing the request, but no response is available yet."
        case .ok:
            "The request was successful and the server has returned the requested data."
        case .created:
            "The request has been fulfilled, resulting in the creation of a new resource."
        case .accepted:
            "The request has been accepted for processing, but processing is not yet complete."
        case .nonAuthoritativeInformation:
            "The returned meta-information in the entity-header is not the definitive set available from the origin server."
        case .noContent:
            "The server successfully processed the request, but there is no new information to send."
        case .resetContent:
            "The server has fulfilled the request and the user agent should reset the document view which caused the request to be sent."
        case .partialContent:
            "The server has fulfilled the partial GET request for the resource."
        case .multiStatus:
            "The response requires multiple responses to complete the request."
        case .alreadyReported:
            "The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again."
        case .imUsed:
            "The server has completed the request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance."
        case .multipleChoices:
            "The requested resource corresponds to any one of a set of representations."
        case .movedPermanently:
            "The requested resource has been assigned a new permanent URI and any future references to this resource should use one of the returned URIs."
        case .found:
            "The requested resource has been temporarily moved to the URL given by the Location header."
        case .seeOther:
            "The response to the request can be found under another URI using the GET method."
        case .notModified:
            "The requested resource has not been modified since the specified time."
        case .useProxy:
            "The requested resource must be accessed through the proxy given by the Location field."
        case .temporaryRedirect:
            "The requested resource resides temporarily under a different URI."
        case .permanentRedirect:
            "The requested resource has been permanently moved to the URL given by the Location header."
        case .badRequest:
            "The request could not be understood or was missing required parameters."
        case .unauthorized:
            "The client must authenticate to get the requested response."
        case .paymentRequired:
            "The payment is required for the requested response."
        case .forbidden:
            "The client does not have permission to access the requested resource."
        case .notFound:
            "The requested resource could not be found."
        case .methodNotAllowed:
            "The method specified in the request is not allowed for the resource identified by the request URI."
        case .notAcceptable:
            "The server cannot produce a response matching the list of acceptable values defined in the request's headers."
        case .proxyAuthenticationRequired:
            "The client must first authenticate itself with the proxy."
        case .requestTimeout:
            "The client did not produce a request within the time that the server was prepared to wait."
        case .conflict:
            "The request could not be completed due to a conflict with the current state of the resource."
        case .gone:
            "The requested resource is no longer available at the server and no forwarding address is known."
        case .lengthRequired:
            "The server requires a content-length in the request."
        case .preconditionFailed:
            "The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server."
        case .payloadTooLarge:
            "The server is refusing to process a request because the request payload is larger than the server is willing or able to process."
        case .uriTooLong:
            "The server is refusing to service the request because the request-target is longer than the server is willing to interpret."
        case .unsupportedMediaType:
            "The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the method requested."
        case .rangeNotSatisfiable:
            "The client has asked for a portion of the file (byte serving), but the server cannot supply that portion."
        case .expectationFailed:
            "The expectation given in the request's Expect header field could not be met by the server."
        case .imATeapot:
            "The HTCPCP server is a teapot that is not capable of brewing coffee."
        case .misdirectedRequest:
            "The request was directed at a server that is not able to produce a response."
        case .unprocessableEntity:
            "The server understands the content type of the request entity, and the syntax of the request entity is correct, but it was unable to process the contained instructions."
        case .locked:
            "The resource that is being accessed is locked."
        case .failedDependency:
            "The method could not be performed on the resource because the requested action depended on another action and that action failed."
        case .tooEarly:
            "The server is unwilling to risk processing a request that might be replayed."
        case .upgradeRequired:
            "The client should switch to a different protocol such as TLS/1.0."
        case .preconditionRequired:
            "The origin server requires the request to be conditional."
        case .tooManyRequests:
            "The user has sent too many requests in a given amount of time."
        case .requestHeaderFieldsTooLarge:
            "The server is refusing to process the request because the request's headers are too large."
        case .unavailableForLegalReasons:
            "The requested resource is unavailable for legal reasons."
        case .internalServerError:
            "An error occurred on the server."
        case .notImplemented:
            "The server does not support the functionality required to fulfill the request."
        case .badGateway:
            "The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request."
        case .serviceUnavailable:
            "The server is currently unable to handle the request due to temporary overloading or maintenance of the server."
        case .gatewayTimeout:
            "The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server or some other auxiliary server it needed to access in order to complete the request."
        case .httpVersionNotSupported:
            "The server does not support the HTTP protocol version that was used in the request."
        case .variantAlsoNegotiates:
            "The server has an internal configuration error: the chosen variant resource is configured to engage in transparent content negotiation itself, and is therefore not a proper end point in the negotiation process."
        case .insufficientStorage:
            "The method could not be performed on the resource because the server is unable to store the representation needed to successfully complete the request."
        case .loopDetected:
            "The server detected an infinite loop while processing the request."
        case .notExtended:
            "Further extensions to the request are required for the server to fulfill it."
        case .networkAuthenticationRequired:
            "The client must authenticate itself to get network access."
        case .unknown:
            "An unknown error occurred."
        }
    }
}
