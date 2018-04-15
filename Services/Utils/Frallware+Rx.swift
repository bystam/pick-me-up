//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import Frallware
import RxSwift

public extension NetworkTask {

    public func asSingle() -> Single<T> {
        return Single.create(subscribe: { handler -> Disposable in

            self.onResult { result in
                switch result {
                case .success(let response):
                    handler(.success(response))
                case .failure(let error):
                    handler(.error(error))
                }
            }.start()

            return Disposables.create {
                self.cancel()
            }
        })
    }
}

public extension NetworkTask where T == Void {

    public func asCompletable() -> Completable {
        return Completable.create(subscribe: { handler -> Disposable in

            self.onResult { result in
                switch result {
                case .success(_):
                    handler(.completed)
                case .failure(let error):
                    handler(.error(error))
                }
            }.start()

            return Disposables.create {
                self.cancel()
            }
        })
    }
}
