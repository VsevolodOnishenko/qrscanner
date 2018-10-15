//
//  QRCodeViewController.swift
//  QRCodeReader
//
//  Created by Vsevolod Onishchenko on 15.10.2018.
//  Copyright © 2016 OneActionApp. All rights reserved.
//

import UIKit

final class QRCodeViewController: UIViewController {

    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

}
