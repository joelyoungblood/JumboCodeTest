# JumboCodeTest

The basic architecture of this challenge is simple: we have the challenge json represented as a model (I've become a big fan of using Codable/Decodable - never were any JSON parsing libraries in Swift I found particularly great - the built in solution is my preferred way now for sure). We fetch this model using our two Networking classes - `Network.swift` which handles the actual communication with the server, and then `Request.swift` which handles the specific request to a given API, decodes the model, and returns an RxSwift `Observable` of that model. Within `ViewModel.swift` we call our Request methods, and when the data is received, call into `Validator.swift` which has a method for validating a given challenge. Based around the results of that validation attempt, we then proceed to either inject the JS, or show an error.

# Pods

- Alamofire: Has been my go to networking solution for as long as it has existed and I've been using Swift  - and it was AFNetworking before ;)
- RxSwift/RxCocoa - I contemplated whether or not I should use RxSwift given the small size of the networking/asynchronous requirements of this challenge, but at the end of the day I believe in a strong fundamental architecture, irregardless of the size of the project, so decided 'my best foot forward' here would be to use what I know and like. RxSwift greatly cleans up asynchronous tasks for my money, and proper use of its various subjects greatly increases the readability of view models.
- NSObject+Rx - A small pod that adds a default implementation of the `DisposeBag` pattern to everything that descends from `NSObject`. A dispose bag is used for lifecycle / memory management in RxSwift, and is usually added manually (e.g. `let disposeBag = DisposeBag()`). This pod just allows that stepped to be skipped on a `UIViewController` or any other `NSObject` derived class.
- RxAlamofire - A community extension that adds RxSwift support to Alamofire. If you are using both Alamofire and RxSwift, it's a no brainer!
- SnapKit - My preferred autolayout DSL. Again, given the extremely small UI requirements of the coding challenge, I was tempted to do it using the Apple syntax, but believed in showcasing a 'realistic' look at my code, and how I like to build my UI's, and currently my preferred way is using SnapKit (never cared for Storyboards, and apples on autolayout DSL is...verbose...)

## Installation

Clone or download the repo, and run `pod install` on the project directory.