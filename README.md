# ZemogaMobileTest
Zemoga Mobile Test

# how to run the app, 
- Launch de App & press button refresh **↻** on top bar buttons

# The proposed architecture

# Architecture:
Clean Architecture
Pros:
1. Separation of concerns.
2. Independent of Frameworks.
3. Testable.
4. Independent of UI.
5. Independent of Database.
6. Independent of any external agency.
https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

# Technologies
- Built-in library

# SwiftUI
1. Manage the flow of data from your app’s models down to the views
https://developer.apple.com/documentation/swiftui/

# Combine
1. Declarative Swift API for processing values that can change over time. 
2. Asynchronous events.
https://developer.apple.com/documentation/combine

# Third-party library

# SwiftMock:
1. objects pre-programmed with expectations which form a specification of the calls they are expected to receive.
https://martinfowler.com/bliki/TestDouble.html

# OHHTTPStubs:
1. test your apps with fake network data (stubbed from file) and simulate slow networks, to check your application behavior in bad network conditions
https://github.com/AliSoftware/OHHTTPStubs

# ViewInspector for SwiftUI:
1. It allows for traversing a view hierarchy at runtime providing direct access to the underlying View structs.
https://github.com/nalexn/ViewInspector

# Methodology(Best practices):
# TDD
1. Allows you to understand the use cases of the system before writing (complex) code
2. Allows you to make safe changes verified by tests that support its deterministic operation (input->processing->output).
3. allows you to have a specific time to refactor the written code to clean code.
https://en.wikipedia.org/wiki/Test-driven_development
