//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Frallware
import RxSwift

public extension NetworkTask {

    public func asSingle() -> Single<T> {
        return Single.create(subscribe: { handler -> Disposable in

            self.onResponse { value in
                    handler(.success(value))
                }
                .onError { error in
                    handler(.error(error))
                }
                .start()

            return Disposables.create {
                self.cancel()
            }
        })
    }
}

public extension NetworkTask where T == Void {

    public func asCompletable() -> Completable {
        return Completable.create(subscribe: { handler -> Disposable in

            self.onSuccess {
                    handler(.completed)
                }
                .onError { error in
                    handler(.error(error))
                }
                .start()

            return Disposables.create {
                self.cancel()
            }
        })
    }
}
