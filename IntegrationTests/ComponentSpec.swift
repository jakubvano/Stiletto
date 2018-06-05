import Quick
import Nimble

class ComponentSpec: QuickSpec {
    override func spec() {
        var component: PersonComponent!
        beforeEach { component = StilettoPersonComponent() }

        describe("constructor injection") {
            it("uses annotated constructor for type instantiation") {
                expect(component.child.parent).notTo(beNil())
            }
        }
        describe("property injection") {
            it("injects annotated implicitly unwrapped property") {
                expect(component.child.school).notTo(beNil())
            }
        }
    }
}

// sourcery: Component
protocol PersonComponent {
    var parent: Parent { get }
    var child: Child { get }
}

class Building {
    // sourcery: Inject
    init() {}
}

class Parent {
    // sourcery: Inject
    init(home: Building) {}
}

class Child {
    let parent: Parent?

    // sourcery: Inject
    var school: Building!

    // sourcery: Inject
    init(parent: Parent) { self.parent = parent }

    init() { self.parent = nil }
}
