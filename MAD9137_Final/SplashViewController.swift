//
//  SplashViewController.swift
//  MAD9137_Final
//
//  Created by Ravi Rachamalla on 2020-12-02.
//

import UIKit

class SplashViewController: UIViewController {
    // properties for the SplashViewController
    // first create an optional timer object
    var splashTimer : Timer?
    // methods for the SplashViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Because the SpalshView will just show the splash screen and launch the Application
        // we will just call the Indentifier 'ShowPassportTable' after 3 seconds by setting our timer
        // the Timer will file after 3 seconds never repeating and will fire the method callback defined below
        self.splashTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showPassportTableViewCallback), userInfo: nil, repeats: true)
        guard self.splashTimer != nil else {
            return // return early if the splashTimer was not set correctly
        }
        self.splashTimer!.fire()
    }
    
    // method callback to preform the segue and disconnect the timer
    @objc func showPassportTableViewCallback(){
        // disconnect the timer to stop repeated firing after checking it exists
        guard self.splashTimer != nil else {
            return // return early if the splashTimer does not exist
        }
        self.splashTimer?.invalidate()
        self.splashTimer = nil
        
        // preform the segue
        self.performSegue(withIdentifier: "ShowPassportTable", sender: nil)
        print("preforming segue to the navigation controller...")
       
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }

}
