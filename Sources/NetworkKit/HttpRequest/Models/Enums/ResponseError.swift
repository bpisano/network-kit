//
//  File.swift
//  
//
//  Created by Benjamin Pisano on 09/08/2023.
//

import Foundation

public enum ResponseError: Int, LocalizedError {
    case continueRequest = 100
    case switchingProtocols = 101
    case processing = 102
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case temporaryRedirect = 307
    case permanentRedirect = 308
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case tooEarly = 425
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
    case unknown = 0

    static func from(statusCode: Int) -> ResponseError {
        ResponseError(rawValue: statusCode) ?? .unknown
    }

    public var errorDescription: String? {
        switch self {
        case .continueRequest:
            return "The server has received the request headers and the client should proceed to send the request body."
        case .switchingProtocols:
            return "The server is switching protocols according to the client request."
        case .processing:
            return "The server is processing the request, but no response is available yet."
        case .multipleChoices:
            return "The requested resource corresponds to any one of a set of representations."
        case .movedPermanently:
            return "The requested resource has been assigned a new permanent URI and any future references to this resource should use one of the returned URIs."
        case .found:
            return "The requested resource has been temporarily moved to the URL given by the Location header."
        case .seeOther:
            return "The response to the request can be found under another URI using the GET method."
        case .notModified:
            return "The requested resource has not been modified since the specified time."
        case .useProxy:
            return "The requested resource must be accessed through the proxy given by the Location field."
        case .temporaryRedirect:
            return "The requested resource resides temporarily under a different URI."
        case .permanentRedirect:
            return "The requested resource has been permanently moved to the URL given by the Location header."
        case .badRequest:
            return "The request could not be understood or was missing required parameters."
        case .unauthorized:
            return "The client must authenticate to get the requested response."
        case .paymentRequired:
            return "The payment is required for the requested response."
        case .forbidden:
            return "The client does not have permission to access the requested resource."
        case .notFound:
            return "The requested resource could not be found."
        case .methodNotAllowed:
            return "The method specified in the request is not allowed for the resource identified by the request URI."
        case .notAcceptable:
            return "The server cannot produce a response matching the list of acceptable values defined in the request's headers."
        case .proxyAuthenticationRequired:
            return "The client must first authenticate itself with the proxy."
        case .requestTimeout:
            return "The client did not produce a request within the time that the server was prepared to wait."
        case .conflict:
            return "The request could not be completed due to a conflict with the current state of the resource."
        case .gone:
            return "The requested resource is no longer available at the server and no forwarding address is known."
        case .lengthRequired:
            return "The server requires a content-length in the request."
        case .preconditionFailed:
            return "The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server."
        case .payloadTooLarge:
            return "The server is refusing to process a request because the request payload is larger than the server is willing or able to process."
        case .uriTooLong:
            return "The server is refusing to service the request because the request-target is longer than the server is willing to interpret."
        case .unsupportedMediaType:
            return "The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the method requested."
        case .rangeNotSatisfiable:
            return "The client has asked for a portion of the file (byte serving), but the server cannot supply that portion."
        case .expectationFailed:
            return "The expectation given in the request's Expect header field could not be met by the server."
        case .imATeapot:
            return "The HTCPCP server is a teapot that is not capable of brewing coffee."
        case .misdirectedRequest:
            return "The request was directed at a server that is not able to produce a response."
        case .unprocessableEntity:
            return "The server understands the content type of the request entity, and the syntax of the request entity is correct, but it was unable to process the contained instructions."
        case .locked:
            return "The resource that is being accessed is locked."
        case .failedDependency:
            return "The method could not be performed on the resource because the requested action depended on another action and that action failed."
        case .tooEarly:
            return "The server is unwilling to risk processing a request that might be replayed."
        case .upgradeRequired:
            return "The client should switch to a different protocol such as TLS/1.0."
        case .preconditionRequired:
            return "The origin server requires the request to be conditional."
        case .tooManyRequests:
            return "The user has sent too many requests in a given amount of time."
        case .requestHeaderFieldsTooLarge:
            return "The server is refusing to process the request because the request's headers are too large."
        case .unavailableForLegalReasons:
            return "The requested resource is unavailable for legal reasons."
        case .internalServerError:
            return "An error occurred on the server."
        case .notImplemented:
            return "The server does not support the functionality required to fulfill the request."
        case .badGateway:
            return "The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request."
        case .serviceUnavailable:
            return "The server is currently unable to handle the request due to temporary overloading or maintenance of the server."
        case .gatewayTimeout:
            return "The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server or some other auxiliary server it needed to access in order to complete the request."
        case .httpVersionNotSupported:
            return "The server does not support the HTTP protocol version that was used in the request."
        case .variantAlsoNegotiates:
            return "The server has an internal configuration error: the chosen variant resource is configured to engage in transparent content negotiation itself, and is therefore not a proper end point in the negotiation process."
        case .insufficientStorage:
            return "The method could not be performed on the resource because the server is unable to store the representation needed to successfully complete the request."
        case .loopDetected:
            return "The server detected an infinite loop while processing the request."
        case .notExtended:
            return "Further extensions to the request are required for the server to fulfill it."
        case .networkAuthenticationRequired:
            return "The client must authenticate itself to get network access."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
