//
//  Copyright © 2018 Frallware. All rights reserved.
//

import Foundation
import CoreGraphics

public struct FeedEntry {
    public let title: String
    public let image: FeedImage
}

public struct FeedImage {
    public let size: CGSize
    public let url: URL
}
