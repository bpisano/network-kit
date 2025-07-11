//
//  HttpMethodMacros.swift
//  NetworkKit
//
//  Created by Benjamin Pisano on 07/07/2025.
//

/// A macro that creates a GET request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct GetUsersRequest: HttpRequest {
///     let path = "/users"
///     let method: HttpMethod = .get
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Get("/users")
/// struct GetUsersRequest {
///     @Query
///     var page: Int
///
///     @Query
///     var limit: Int
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Get(_ path: String) = #externalMacro(module: "NetworkKitMacros", type: "GetMacro")

/// A macro that creates a POST request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct CreateUserRequest: HttpRequest {
///     let path = "/users"
///     let method: HttpMethod = .post
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Post("/users")
/// struct CreateUserRequest {
///     let body: User
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Post(_ path: String) = #externalMacro(module: "NetworkKitMacros", type: "PostMacro")

/// A macro that creates a PUT request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct UpdateUserRequest: HttpRequest {
///     let path = "/users/:id"
///     let method: HttpMethod = .put
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Put("/users/:id")
/// struct UpdateUserRequest {
///     @Path
///     var id: String
///
///     let body: User
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Put(_ path: String) = #externalMacro(module: "NetworkKitMacros", type: "PutMacro")

/// A macro that creates a PATCH request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct PatchUserRequest: HttpRequest {
///     let path = "/users/:id"
///     let method: HttpMethod = .patch
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Patch("/users/:id")
/// struct PatchUserRequest {
///     @Path
///     var id: String
///
///     let body: PartialUser
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Patch(_ path: String) = #externalMacro(module: "NetworkKitMacros", type: "PatchMacro")

/// A macro that creates a DELETE request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct DeleteUserRequest: HttpRequest {
///     let path = "/users/:id"
///     let method: HttpMethod = .delete
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Delete("/users/:id")
/// struct DeleteUserRequest {
///     @Path
///     var id: String
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Delete(_ path: String) =
    #externalMacro(module: "NetworkKitMacros", type: "DeleteMacro")

/// A macro that creates an OPTIONS request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct OptionsRequest: HttpRequest {
///     let path = "/users"
///     let method: HttpMethod = .options
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Options("/users")
/// struct OptionsRequest {
///     // No body needed for OPTIONS requests
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Options(_ path: String) =
    #externalMacro(module: "NetworkKitMacros", type: "OptionsMacro")

/// A macro that creates a HEAD request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct HeadRequest: HttpRequest {
///     let path = "/users/:id"
///     let method: HttpMethod = .head
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Head("/users/:id")
/// struct HeadRequest {
///     @Path
///     var id: String
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Head(_ path: String) = #externalMacro(module: "NetworkKitMacros", type: "HeadMacro")

/// A macro that creates a TRACE request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct TraceRequest: HttpRequest {
///     let path = "/debug"
///     let method: HttpMethod = .trace
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Trace("/debug")
/// struct TraceRequest {
///     // TRACE requests typically don't have a body
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Trace(_ path: String) = #externalMacro(module: "NetworkKitMacros", type: "TraceMacro")

/// A macro that creates a CONNECT request with the specified path.
///
/// This macro automatically adds the `path` and `method` properties to the struct
/// and makes it conform to `HttpRequest`. It's equivalent to manually implementing:
///
/// ```swift
/// struct ConnectRequest: HttpRequest {
///     let path = "/proxy"
///     let method: HttpMethod = .connect
///     // ... other properties
/// }
/// ```
///
/// ## Usage
///
/// ```swift
/// @Connect("/proxy")
/// struct ConnectRequest {
///     // CONNECT requests are typically used for proxy tunneling
/// }
/// ```
///
/// - Parameter path: The path for the HTTP request
@attached(member, names: named(path), named(method))
@attached(extension, conformances: HttpRequest)
public macro Connect(_ path: String) =
    #externalMacro(module: "NetworkKitMacros", type: "ConnectMacro")
