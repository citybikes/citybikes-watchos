//
//  InterfaceController.swift
//  Citybikes WatchKit Extension
//
//  Created by Wojtek Siudzinski on 24/09/2019.
//  Copyright © 2019 Gaia Green Tech. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftUI

class InterfaceController: WKHostingController<ContentView> {
    weak var extensionDelegate: ExtensionDelegate!
    var distance: Int?

    override var body: ContentView {
        return ContentView(model: extensionDelegate.model!)
    }

    override func awake(withContext context: Any?) {
        extensionDelegate = WKExtension.shared().delegate as? ExtensionDelegate
        super.awake(withContext: context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
