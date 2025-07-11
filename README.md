# NetworkKit

A modern, type-safe networking library for Swift with async/await support.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Request Types](#request-types)
  - [GET Request](#get-request)
  - [POST Request with Body](#post-request-with-body)
  - [PUT Request with Path Parameters](#put-request-with-path-parameters)
  - [DELETE Request](#delete-request)
- [Path and Query Parameters](#path-and-query-parameters)
  - [Path Parameters](#path-parameters)
  - [Query Parameters](#query-parameters)
- [HTTP Body](#http-body)
  - [JSON Body](#json-body)
  - [Data Body](#data-body)
  - [Custom Body Types](#custom-body-types)
- [File Uploads](#file-uploads)
  - [Multipart Form](#multipart-form)
- [Middleware](#middleware)
- [Interceptors](#interceptors)
- [Custom Logging](#custom-logging)
- [Progress Tracking](#progress-tracking)

## Installation

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/bpisano/network-kit", .upToNextMajor(from: "1.0.0"))
]
```

## Quick Start

NetworkKit distinguishes between **clients** and **requests**. This separation allows you to use the same requests across different server environments (dev, staging, prod), configure each environment with its own base URL and settings, and keep your request logic environment-agnostic.

### Create a Client

A client represents a server environment with its base URL and configuration:

```swift
let client = Client("https://api.example.com")
```

### Define a Request

Requests define the API endpoints and parameters. They're reusable across all environments:

```swift
@Get("/users/:id")
struct GetUserRequest {
    @Path
    var id: String
    
    @Query
    var includePosts: Bool
}
```

### Make a Request

```swift
let request = GetUserRequest(
    id: "123"
    includePosts: true
)
let response: Response<User> = try await client.perform(request)
let user = response.data
```

## Request Types

NetworkKit comes with several macros to simplify and streamline request declaration.

### GET Request

```swift
@Get("/users")
struct GetUsersRequest {
    @Query
    var page: Int
    
    @Query
    var limit: Int
}
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/users?page=1&limit=20
```

</details>

### POST Request with Body

```swift
@Post("/users")
struct CreateUserRequest {
    let body: User
}

struct User: Codable {
    let name: String
    let email: String
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
```

</details>

### PUT Request with Path Parameters

```swift
@Put("/users/:id")
struct UpdateUserRequest {
    @Path
    var id: String
    
    let body: User
}
```

<details>
<summary>Click to see the generated request</summary>

```http
PUT https://api.example.com/users/123
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
```

</details>

### DELETE Request

```swift
@Delete("/users/:id")
struct DeleteUserRequest {
    @Path
    var id: String
}
```

<details>
<summary>Click to see the generated request</summary>

```http
DELETE https://api.example.com/users/123
```

</details>

## Path and Query Parameters

### Path Parameters

Use `@Path` for URL path parameters. These are replaced in the URL path at runtime:

```swift
@Get("/users/:id/posts/:postId")
struct GetPostRequest {
    @Path
    var id: String
    
    @Path
    var postId: String
}
```

> The path in the macro should use a colon (e.g., `:id`) to indicate a path parameter, and the corresponding Swift property name in your struct must match the parameter name. For example, if your macro is `@Get("/users/:id/posts/:postId")`, your struct should have properties named `id` and `postId`.

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/users/123/posts/456
```

</details>

### Query Parameters

Use `@Query` for URL query parameters. These are automatically added to the URL:

```swift
@Get("/search")
struct SearchRequest {
    @Query
    var query: String
    
    @Query
    var page: Int
    
    @Query
    var limit: Int
}
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/search?query=swift&page=1&limit=20
```

</details>

## HTTP Body

NetworkKit automatically handles HTTP body serialization for your requests. Simply include a `body` property in your request struct, and it will be serialized according to the `HttpBody` protocol implementation.

The `HttpBody` protocol defines how your data should be serialized for HTTP requests. NetworkKit provides default implementations for common types like `Codable` objects (which are serialized as JSON) and `Data` (which are sent as binary data).

### JSON Body

```swift
@Post("/users")
struct CreateUserRequest {
    let body: User
}

struct User: HttpBody {
    let name: String
    let email: String
    let age: Int
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}
```

</details>

### Data Body

For binary data, you can use `Data` directly as the body type:

```swift
@Post("/upload")
struct UploadDataRequest {
    let body: Data
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/upload
Content-Type: application/octet-stream

[Binary data]
```

</details>

### Custom Body Types

You can also create custom body types that conform to `HttpBody`:

```swift
struct CustomBody: HttpBody {
    let content: String
    
    func modify(_ request: inout URLRequest, using encoder: JSONEncoder) throws {
        let data = content.data(using: .utf8) ?? Data()
        request.httpBody = data
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
    }
}

@Post("/custom")
struct CustomRequest {
    let body: CustomBody
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/custom
Content-Type: text/plain

Hello, World!
```

</details>

## File Uploads

### Multipart Form

NetworkKit supports multipart form data for file uploads. You can mix files and text fields in a single request:

```swift
@Post("/upload")
struct UploadRequest {
    let body: MultipartForm
    
    init(fileData: Data, fileName: String, description: String) {
        self.body = MultipartForm {
            DataField(
                named: "file",
                data: fileData,
                mimeType: .jpegImage,
                fileName: fileName
            )
            TextField(named: "description", value: description)
        }
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/upload
Content-Type: multipart/form-data; boundary=networkkit

--networkkit
Content-Disposition: form-data; name="file"; filename="photo.jpg"
Content-Type: image/jpeg

[Binary image data]
--networkkit
Content-Disposition: form-data; name="description"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

My vacation photo
--networkkit--
```

</details>

## Middleware

Middleware allows you to modify requests before they are sent. This is useful for adding authentication headers, logging, or transforming request data.

```swift
struct AuthMiddleware: Middleware {
    let token: String
    
    func modify(request: inout URLRequest) async throws {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}

var client = Client("https://api.example.com")
client.middlewares = [AuthMiddleware(token: "your-token")]
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/users
Authorization: Bearer your-token
```

</details>

## Interceptors

Interceptors allow you to modify responses after they are received but before they are processed. This is useful for error handling, response transformation, or retry logic.

```swift
struct RetryInterceptor: Interceptor {
    func intercept(
        data: Data,
        response: URLResponse,
        client: HttpClient,
        request: some HttpRequest
    ) async throws -> (data: Data, response: URLResponse) {
        // Add retry logic here
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode >= 500 {
            // Retry the request
        }
        return (data, response)
    }
}

var client = Client("https://api.example.com")
client.interceptors = [RetryInterceptor()]
```

## Custom Logging

NetworkKit includes built-in logging, but you can create custom loggers to integrate with your preferred logging system:

```swift
struct CustomLogger: ClientLogger {
    func logPerform(request: URLRequest) {
        print("🚀 \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
    }
    
    func logResponse(request: URLRequest, response: URLResponse, data: Data) {
        if let httpResponse = response as? HTTPURLResponse {
            print("📥 \(httpResponse.statusCode)")
        }
    }
}

var client = Client("https://api.example.com")
client.logger = CustomLogger()
```

<details>
<summary>Click to see the log output</summary>

```
🚀 GET https://api.example.com/users/123
📥 200
```

</details>

## Progress Tracking

Track download progress for large files or responses:

```swift
let response = try await client.perform(request) { progress in
    print("Download progress: \(progress.fractionCompleted)")
}
```

## Licence

NetworkKit is released under the MIT License.
