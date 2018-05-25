// swiftlint:disable function_body_length

import Quick
import Nimble

class ComponentSpec: QuickSpec {
    override func spec() {
        var component: PersonComponent!
        beforeEach { component = StilettoPersonComponent.create() }

        describe("constructor injection") {
            it("uses annotated constructor for type instantiation") {
                let _ = component.parent
            }
        }
    }
}


// sourcery: Component
protocol PersonComponent {
    var parent: Parent { get }
    var child: Child { get }
}

class Parent {
    // sourcery: Inject
    init() {}
}

class Child {
    // sourcery: Inject
    init() {}
}
