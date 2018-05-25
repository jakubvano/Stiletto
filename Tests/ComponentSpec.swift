// swiftlint:disable function_body_length

import Quick
import Nimble

class ComponentSpec: QuickSpec {
    override func spec() {
        var component: PersonComponent!
        beforeEach { component = StilettoPersonComponent.create() }

        describe("constructor injection") {
            it("uses annotated constructor for type instantiation") {
                expect(component.child.parent).notTo(beNil())
            }
        }
    }
}


// sourcery: Component
protocol PersonComponent {
    var parent: Parent { get }
    var child: Child { get }
}

class Home {
    // sourcery: Inject
    init() {}
}

class Parent {
    // sourcery: Inject
    init(home: Home) {}
}

class Child {
    let parent: Parent?

    // sourcery: Inject
    init(parent: Parent) { self.parent = parent }

    init() { self.parent = nil }
}
