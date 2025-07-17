@attached(extension, conformances: HttpBody)
public macro Body() =
    #externalMacro(module: "NetworkKitMacros", type: "BodyMacro")
