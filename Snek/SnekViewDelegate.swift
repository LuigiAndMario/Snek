//
//  SnekViewDelegate.swift
//  Snek
//
//  Created by Luigi Sansonetti on 12.11.16.
//  Copyright © 2016 Luigi Sansonetti. All rights reserved.
//

import UIKit

protocol SnekViewDelegate {
    func snekForSnekView(view: SnekView) -> Snek?
    func fruitForSnekView(view: SnekView) -> Point?
}
