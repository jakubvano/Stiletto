//
//  Copyright © 2018 Cleverlance. All rights reserved.
//

open class Provider<T> {
    open var instance: T { fatalError() }

    public init() {}
}
