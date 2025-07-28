//
//  HttpMethodMacros.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

/// A macro that creates a GET request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// // With explicit response type:
/// @Get("/users", of: [User].self)
/// struct GetUsersRequest {
///     // This will generate: typealias Response = [User]
///     @Query
///     var page: Int
///
///     @Query
///     var limit: Int
/// }
///
/// // With default EmptyResponse:
/// @Get("/users/refresh")
/// struct RefreshUsersRequest {
///     // This will generate: typealias Response = EmptyResponse
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Get<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "GetMacro")

/// A macro that creates a POST request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// @Post("/users", of: User.self)
/// struct CreateUserRequest {
///     // This will generate: typealias Response = User
///     let body: User
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Post<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "PostMacro")

/// A macro that creates a PUT request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// @Put("/users/:id", of: User.self)
/// struct UpdateUserRequest {
///     // This will generate: typealias Response = User
///     @Path
///     var id: String
///
///     let body: User
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Put<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "PutMacro")

/// A macro that creates a PATCH request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// @Patch("/users/:id", of: User.self)
/// struct PatchUserRequest {
///     // This will generate: typealias Response = User
///     @Path
///     var id: String
///
///     let body: PartialUser
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Patch<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "PatchMacro")

/// A macro that creates a DELETE request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// // With explicit response type:
/// @Delete("/users/:id", of: DeleteResponse.self)
/// struct DeleteUserRequest {
///     // This will generate: typealias Response = DeleteResponse
///     @Path
///     var id: String
/// }
///
/// // With default EmptyResponse:
/// @Delete("/users/:id")
/// struct DeleteUserRequest {
///     // This will generate: typealias Response = EmptyResponse
///     @Path
///     var id: String
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Delete<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "DeleteMacro")

/// A macro that creates an OPTIONS request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// @Options("/users", of: OptionsResponse.self)
/// struct OptionsRequest {
///     // This will generate: typealias Response = OptionsResponse
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Options<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "OptionsMacro")

/// A macro that creates a HEAD request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// @Head("/users/:id", of: HeadResponse.self)
/// struct HeadRequest {
///     // This will generate: typealias Response = HeadResponse
///     @Path
///     var id: String
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Head<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "HeadMacro")

/// A macro that creates a TRACE request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// @Trace("/debug", of: TraceResponse.self)
/// struct TraceRequest {
///     // This will generate: typealias Response = TraceResponse
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Trace<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "TraceMacro")

/// A macro that creates a CONNECT request with the specified path and response type.
///
/// This macro automatically adds the `path`, `method`, and `Response` typealias properties to the struct
/// and makes it conform to `HttpRequest`.
///
/// ## Usage
///
/// ```swift
/// @Connect("/proxy", of: ConnectResponse.self)
/// struct ConnectRequest {
///     // This will generate: typealias Response = ConnectResponse
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
/// - Parameter of: The expected response type (defaults to Empty.self)
@attached(
    member, names: named(path), named(method), named(queryParameters), named(body), named(Response))
@attached(extension, conformances: HttpRequest)
public macro Connect<T: Decodable>(_ path: String, of responseType: T.Type = Empty.self) =
    #externalMacro(module: "NetworkKitMacros", type: "ConnectMacro")
