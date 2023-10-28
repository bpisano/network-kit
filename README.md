# NetworkKit

A versatile Swift package that simplifies HTTP requests, enabling efficient communication with APIs and servers in your apps.

### Key Features

1. **Separation of Client and Request**: NetworkKit distinguishes between client configuration and request creation allowing each request to reside in its own file. This modularity is beneficial for managing various client environments, including development, preproduction, and production.
2. **Modern Request Body Construction**: The `HttpRequest` protocol simplifies the process of defining HTTP methods, headers, query parameters, and body content.
3. **Automated Refresh Token Management**: NetworkKit simplifies access token handling through the `AccessTokenProvider` protocol. Efficiently manage token refreshes, ensuring consistent and secure communication with APIs.
4. **Per-Request Error Handling**: Define custom error behaviors and contextual descriptions for specific status codes.

# Installation

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/bpisano/network-kit", .upToNextMajor(from: "0.1.0"))
]
```

# Quick start

1. **Create a Client Configuration**: Define a client configuration using a `struct` that conforms to the `Client` protocol. You can create your own client structure based on your client's URL and configuration.

```swift
struct MyClient: Client {
    let host: String = "api.example.com"
}
```

2. **Define a Request**: Create a request structure that conforms to the `HttpRequest` protocol. For this example, let's assume you have a request to retrieve a list of articles:

```swift
struct GetArticlesRequest: HttpRequest {
    let path: String = "/articles"
    let method: HttpMethod = .get // optional, defaults to .get
}
```

3. **Perform the Request**: Use the client configuration to perform the request.

```swift
let client = MyClient()
let articles: [Article] = try await client.perform(GetArticlesRequest())
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/articles
```

</details>

<details>
<summary><h1>HttpRequest</h1></summary>

To define a custom HTTP request, you need to create a structure that conforms to the `HttpRequest` protocol. This protocol defines the properties and methods required to construct a complete HTTP request. Here's a breakdown of the key components you can customize:

| Parameter         | Description                                                                       |
|-------------------|-----------------------------------------------------------------------------------|
| `path`            | URL path of the request (excluding base client URL)                              |
| `method`          | HTTP method to be used for the request (e.g., GET, POST, PUT, DELETE)            |
| `headers`         | Additional headers required for the request                                      |
| `queryParameters` | Query parameters to include in the URL                                           |
| `body`            | Body of the request (can be customized based on data format)                     |
| `jsonEncoder`     | JSON encoder to use for encoding the request's body data                         |
| `successStatusCodes` | Array of status codes interpreted as successful responses                      |
| `timeout`         | Maximum time interval for waiting for a response                                 |
| `cachePolicy`     | Caching behavior for the request                                                |

## Headers

To include custom headers in your request, use the `headers` property within a structure that conforms to the `HttpRequest` protocol. This property enables you to specify one or more headers, enriching the context and behavior of your request.

Consider the following example of a request to retrieve user data while including custom headers:

```swift
struct GetUserRequest: HttpRequest {
    let path: String = "/user"

    var headers: HttpHeaders? {
        HttpHeader("Language", value: "fr-FR")
        HttpHeader("Client-Version", value: "2.0")
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/user
Headers:
    Language: fr-FR
    Client-Version: 2.0
```

</details>

The `@HttpHeadersBuilder` result builder streamlines the process of combining multiple headers within the headers property.

## Query parameters

To include query parameters in your request, use the `queryParameters` property within a structure that conforms to the `HttpRequest` protocol. This property allows you to specify one or more query parameters, enhancing the specificity and context of your request.

For example, consider the following request to retrieve user data by providing an `id` parameter:

```swift
struct GetUserRequest: HttpRequest {
    let path: String = "/user"

    private let id: String

    init(id: String) {
        self.id = id
    }

    var queryParameters: HttpQueryParameters? {
        HttpQueryParameter("id", value: id)
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/user?id=YOUR_ID
```

</details>

You can also combine multiple query parameters by taking advantage of the `@HttpQueryParametersBuilder`.

```swift
struct GetPostsRequest: HttpRequest {
    let path: String = "/posts"

    var queryParameters: HttpQueryParameters? {
        HttpQueryParameter("category", value: "technology")
        HttpQueryParameter("author", value: "john_doe")
        HttpQueryParameter("limit", value: "10")
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/posts?category=technology&author=john_doe&limit=10
```

</details>

## Body

### Sending Data in the Request Body

#### Dictionary

You can use a dictionary to represent the request body as its conforms to the `HttpBody` protocol.

```swift
struct LoginRequest: HttpRequest {
    let path: String = "/login"
    let method: HttpMethod = .post

    private let login: String
    private let password: String

    init(
        login: String,
        password: String
    ) {
        self.login = login
        self.password = password
    }

    var body: some HttpBody {
        [
            "login": login,
            "password": password
        ]
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/login
Headers:
    Content-Type: application/json

Body:
{
    "login": "YOUR_LOGIN",
    "password": "YOUR_PASSWORD"
}
```

</details>

#### Using the Encode Struct

For more complex data structures, you can use the `Encode` struct to encode objects conforming to the `Encodable` protocol into the request body.

```swift
struct CreateUserRequest: HttpRequest {
    let path: String = "/user"
    let method: HttpMethod = .post

    private let user: User

    init(user: User) {
        self.user = user
    }

    var body: some HttpBody {
        Encode(user)
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/user
Headers:
    Content-Type: application/json

Body:
{
    "id": "YOUR_ID",
    "username": "YOUR_USERNAME"
}
```

</details>

#### Using the Raw Struct for Raw Data

To send raw data, such as binary or custom formats, you can use the `Raw` struct. This allows you to pass raw data directly as the request body.

```swift
struct UploadDataRequest: HttpRequest {
    let path: String = "/data"
    let method: HttpMethod = .post

    private let data: Data

    init(data: Data) {
        self.data = data
    }

    var body: some HttpBody {
        Raw(data)
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/data
Headers:
    Content-Type: application/octet-stream

Body:
[Binary Data]
```

</details>

### Uploading Files with Multipart Form

For uploading files and text data, NetworkKit provides the `MultipartForm` structure, which handles creating the correct headers and formatting the data for multipart form requests. You can conveniently combine multiple fields within the `MultipartForm` since it uses the `@resultBuilder` Swift property.

#### Uploading Data Field

For sending binary data, you can use the `DataField` structure. This allows you to include raw data in the request body.

```swift
struct PostImageRequest: HttpRequest {
    let path: String = "/image"
    let method: HttpMethod = .post

    private let imageData: Data

    init(imageData: Data) {
        self.imageData = imageData
    }

    var body: some HttpBody {
        MultipartForm {
            DataField(
                named: "image",
                data: imageData,
                mimeType: .jpegImage,
                fileName: "image"
            )
        }
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/image
Content-Type: multipart/form-data; boundary=BOUNDARY_STRING

--BOUNDARY_STRING
Content-Disposition: form-data; name="image"; filename="image"
Content-Type: image/jpeg

[Image Data]

--BOUNDARY_STRING--
```

</details>

#### Uploading Text Field

For sending plain text data, you can use the `TextField` structure. This allows you to include text data in the request body.

```swift
struct UpdateProfileRequest: HttpRequest {
    let path: String = "/profile"
    let method: HttpMethod = .post

    private let bio: String

    init(bio: String) {
        self.bio = bio
    }

    var body: some HttpBody {
        MultipartForm {
            TextField(named: "bio", value: bio)
        }
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
POST https://api.example.com/profile
Content-Type: multipart/form-data; boundary=BOUNDARY_STRING

--BOUNDARY_STRING
Content-Disposition: form-data; name="bio"; filename="bio"
Content-Type: text/plain; charset=ISO-8859-1

[Your Bio Content]

--BOUNDARY_STRING--
```

</details>

## Error Handling

When a request encounters an HTTP response with a non-successful status code, NetworkKit provides the flexibility to define how the package should handle the error. To customize this behavior, override the `failureBehavior(for:)` method in your request structure that conforms to the `HttpRequest` protocol. This method takes the status code as a parameter and returns an instance of `RequestFailureBehavior` that indicates how the error should be handled.

For instance, consider the following example where you want to provide a custom error type with a detailed description for a specific status code:

```swift
struct GetBookRequest: HttpRequest {
    let path: String = "/books"

    private let bookID: String

    init(bookID: String) {
        self.bookID = bookID
    }

    var queryParameters: HttpQueryParameters? {
        HttpQueryParameter("id", value: bookID)
    }

    func failureBehavior(for statusCode: Int) -> RequestFailureBehavior {
        switch statusCode {
        case 404:
            return .throwError(RequestError.bookNotFound(bookID: bookID))
        default:
            return .default
        }
    }
}

extension GetBookRequest {
    enum RequestError: Error, LocalizedError {
        case bookNotFound(bookID: String)

        var errorDescription: String? {
            switch self {
            case .bookNotFound(let bookID):
                return "Book with ID \(bookID) not found."
            }
        }
    }
}
```

<details>
<summary>Click to see the generated request</summary>

```http
GET https://api.example.com/books?id=YOUR_BOOK_ID
```

</details>

In this example, the `GetBookRequest` structure defines a custom error enum `RequestError` for the 404 status code. The `failureBehavior(for:)` method returns `.throwError(RequestError.bookNotFound(bookID: bookID))` for the specified status code, causing the package to throw the custom error enum with its detailed description, including the book ID.

</details>

<details>
<summary><h1>Client</h1></summary>

NetworkKit allows you to configure client settings separately from request creation, promoting scalability and ease of maintenance. This separation enables you to create multiple client configurations, each handling specific requests or targeting different client environments, such as development, preproduction, and production.

## Defining a Client

To configure a client, create a structure that conforms to the `Client` protocol. This structure defines properties such as the client's scheme, host, port, and an optional `AccessTokenProvider` for managing access tokens and their automatic refreshing.

Here's an example of defining a client configuration:

```swift
struct MyClient: Client {
    let scheme: String = "https" // optional. Defaults to "https".
    let host: String = "api.myserver.com"
    let port: Int? = nil // optional. Defaults to nil.
    let accessTokenProvider: AccessTokenProvider? // optional. Defaults to nil.

    init(accessTokenProvider: AccessTokenProvider? = nil) {
        self.accessTokenProvider = accessTokenProvider
    }
}
```

In this example, the `MyClient` structure specifies the client's scheme, host, and an optional access token provider for managing access tokens.

## Client Configuration Properties

When configuring a client using NetworkKit, you have the following properties that can be customized:

| Property                 | Description                                                                     |
|--------------------------|---------------------------------------------------------------------------------|
| `scheme`                 | The scheme of the client (e.g., "http" or "https")                              |
| `host`                   | The base URL of the client (e.g., "api.example.com")                           |
| `port`                   | The port number for the client (optional)                                      |
| `accessTokenProvider`    | An object responsible for managing access tokens and their automatic refreshing |
| `jsonDecoder`                | The decoder used for parsing data responses                                     |

## Performing Requests

NetworkKit provides several methods to perform HTTP requests using the configured client. Each method caters to different scenarios, such as retrieving decoded data, fetching raw data, or simply executing a request.

### Perform and Decode

The `perform` method is used when you want to retrieve and decode data from the client's response. This method takes an `HttpRequest` instance as its parameter and returns a decoded object of the specified type.

```swift
let client = MyClient()
let getUserRequest = GetUserRequest(id: "123")
let user: User = try await client.perform(getUserRequest) // User should conforms to Decodable
```

### Perform Raw

The `performRaw` method is suitable when you want to fetch the raw data of the response without decoding it. This can be useful when you need to access the raw data for purposes such as file downloads.

```swift
let client = MyClient()
let getImageRequest = GetImageRequest(imageID: "456")
let imageData: Data = try await client.performRaw(getImageRequest) // Returns the raw data of the response
```

### Perform Request

If you only want to execute a request without requiring any response data or raw data retrieval, you can use the `perform` method without specifying a return type.

```swift
let client = MyClient()
let deletePostRequest = DeletePostRequest(postID: "789")
try await client.perform(deletePostRequest)
```

</details>

<details>
<summary><h1>AccessTokenProvider</h1></summary>

The NetworkKit package simplifies access token management through the `AccessTokenProvider` protocol and the `AccessTokenType` enum.

### Creating an AccessTokenProvider

To create an `AccessTokenProvider`, implement a class or struct conforming to the protocol. Here's an example:

```swift
final class KeychainAccessTokenProvider: AccessTokenProvider {
    var accessToken: String? {
        // Return the access token stored in the keychain here
    } 

    func refreshAccessToken() async throws {
        accessToken = // Implement token refreshing logic
    }
}
```

### Configuring an AccessTokenProvider in a Client

Inject your custom `AccessTokenProvider` into a client to enable access token management:

```swift
struct MyClient: Client {
    let host: String = "api.example.com"
    let accessTokenProvider: AccessTokenProvider? // add the property of the Client protocol

    // inject the access token provider in the initializer
    init(accessTokenProvider: AccessTokenProvider? = nil) {
        self.accessTokenProvider = accessTokenProvider
    }
}
```

### Setting the AccessTokenType in a Request

Specify how the access token should be added to the request header using the `accessTokenType` property inside a request:

```swift
struct GetUserProfileRequest: HttpRequest {
    let path: String = "/user/profile"
    let method: HttpMethod = .get
    let accessTokenType: AccessTokenType = .bearer
}
```

<details>
<summary>Click to see the generated request</summary>

```http
GET /user/profile
Headers:
    Authorization: Bearer [Access Token]
```

</details>

### Performing a Request with an Access Token

```swift
let accessTokenProvider = KeychainAccessTokenProvider()
let client = MyClient(accessTokenProvider: accessTokenProvider)
let userProfile: UserProfile = try await client.perform(GetUserProfileRequest())
```

When performing a request with an access token, the client will automatically add the token to the request header. If the provided access token is invalid, the client will attempt to refresh it using the `refreshAccessToken` method of the `AccessTokenProvider`. If the refreshed access token is still invalid, an error will be thrown, indicating the failure to authenticate the request.

</details>
