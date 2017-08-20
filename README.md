# OpenWeather for iOS

## General organization

### Getting started on iOS

Just run `carthage update --platform iOS --no-use-binaries` in the root folder, and run the app, let the magic be!

### Dependencies

Since technical debt being a major constraint in the development of an application, the choice of dependencies must be done carefully.
Dependencies in the OpenWeather application are justified by their use and value in the iOS community.

Here is the list of dependencies:

["Alamofire/Alamofire"](https://github.com/Alamofire/Alamofire)
["RxSwiftCommunity/RxAlamofire"](https://github.com/RxSwiftCommunity/RxAlamofire)
["ReactiveX/RxSwift"](https://github.com/ReactiveX/RxSwift)
["RxSwiftCommunity/RxRealm"](https://github.com/RxSwiftCommunity/RxRealm)
["RxSwiftCommunity/RxDataSources"](https://github.com/RxSwiftCommunity/RxDataSources)
["realm/realm-cocoa"](https://github.com/realm/realm-cocoa)
["RxSwiftCommunity/RxRealmDataSources"](https://github.com/RxSwiftCommunity/RxRealmDataSources)
["RxSwiftCommunity/Action"](https://github.com/RxSwiftCommunity/Action)
["RxSwiftCommunity/NSObject-Rx"](https://github.com/RxSwiftCommunity/NSObject-Rx)
["Hearst-DD/ObjectMapper"](https://github.com/Hearst-DD/ObjectMapper)

### Guide style

The guide style is here to help us have consistency across the code and devs. 
Because the end goal is to respect guidelines, it makes sense to use a well known and good writen exising style guide. 
My reference is the [Ray Wenderlich iOS Swift Style Guide](https://github.com/raywenderlich/swift-style-guide).

### Tests

Just run `cmd + U` and see green everywhere !


