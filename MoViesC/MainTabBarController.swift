//
//  MainTabBarController.swift
//  MoViesC
//
//  Created by Lucas Lois on 31/7/21.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onTapLogOut(_ sender: Any) {
        SessionManager.share.logout()
    }

}
