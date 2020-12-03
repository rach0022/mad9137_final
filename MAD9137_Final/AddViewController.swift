//
//  AddViewController.swift
//  MAD9137_Final
//
//  Created by Ravi Rachamalla on 2020-12-02.
//

import UIKit

class AddViewController: UIViewController {
    // the properties of the AddViewController
    // the outlets of the AddViewController
    @IBOutlet weak var passportTitleTextField: UITextField!
    @IBOutlet weak var passportInfoTextView: UITextView!
    @IBOutlet weak var passportArrivalDatePicker: UIDatePicker!
    @IBOutlet weak var passportDepartureDatePicker: UIDatePicker!
    
    // methods for the AddViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // actions connected to the AddViewController
    @IBAction func savePassportBarButtonAction(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
