//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib() -> Self { return Bundle(for: Self.self).loadNibNamed(String(describing: Self.self), owner: nil, options: nil)![0] as! Self }
}
