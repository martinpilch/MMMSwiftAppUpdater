//
//  ViewController.swift
//  MMMSwiftAppUpdater
//
//  Created by Martin Pilch on 04/10/16.
//  Copyright © 2016 Martin Pilch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MMMSwiftAppUpdater.sharedInstance.checkForNewVersionWithCompletion { [weak self] (newVersion: Bool, appURL: NSURL?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let strongSelf = self {
                    if newVersion {
                        strongSelf.setUpdateVersionVisible(true, animated:true)
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

