//
//  AddViewController.swift
//  MAD9137_Final
//
//  Created by Ravi Rachamalla on 2020-12-02.
//

import UIKit
import CoreLocation // used for location access

class AddViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    // the properties of the AddViewController
    // Create a CLLocationManager object used to get location for passport
    var addPassportLocationManager = CLLocationManager()

    // the outlets of the AddViewController
    @IBOutlet weak var passportTitleTextField: UITextField!
    @IBOutlet weak var passportInfoTextView: UITextView!
    @IBOutlet weak var passportArrivalDatePicker: UIDatePicker!
    @IBOutlet weak var passportDepartureDatePicker: UIDatePicker!
    
    // methods for the AddViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the locationManager delegate
        self.addPassportLocationManager.delegate = self

        // Request authorization from user to access location
        self.addPassportLocationManager.requestWhenInUseAuthorization()
    }
    
    // check if the user has allowed permission and if he has not allowed permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Switch on the state of the authorization to decide what to do.
        switch(CLLocationManager.authorizationStatus()) {
        case .restricted, .notDetermined, .denied :
            // If the user has not allowed access stop all updating.
            self.addPassportLocationManager.stopUpdatingLocation()
        case .authorizedWhenInUse,  .authorizedAlways :
            // If the user has allowed access start updating the location of the device.
            self.addPassportLocationManager.startUpdatingLocation()
            print("Updating access Location Manager")
        @unknown default:
            // Manage any future states to be exhaustive.
            print("ERROR: Unable to access Location Manager")
        }
    }

    
    // actions connected to the AddViewController
    @IBAction func savePassportBarButtonAction(_ sender: Any) {
        // close any keyboards that may be open by the text field or view
        passportTitleTextField.resignFirstResponder()
        passportInfoTextView.resignFirstResponder()
        
        // get the form values
//        if let name = eventNameTextField.text, let description = eventDescriptionTextView.text
        // get the values from the text view and text field if they are set
        if let title = passportTitleTextField.text, let description = passportInfoTextView.text{
            // grab the values of the dates
            let arrivalDate = passportArrivalDatePicker.date
            let departureDate = passportDepartureDatePicker.date
            
            var values : [[String: String]] = []
            values.append(["title":title])
            values.append(["description":description])
            values.append(["arrival":arrivalDate.description])
            values.append(["departure":departureDate.description])
            // now lets get the users latitude and longitude, if they do not allow access lets just give (0, 0)
            // Get the current location values if they are set
            if let location = self.addPassportLocationManager.location {
                values.append(["latitude":"\(location.coordinate.latitude)"])
                values.append(["longitude":"\(location.coordinate.longitude)"])
                let newLatitude = location.coordinate.latitude
                let newLongitude = location.coordinate.longitude
                print(newLatitude, newLongitude, values)
           }else {
                values.append(["latitude":"0"]) // default if not supplied
                values.append(["longitude":"0"])
           }
           
            
            // create the passport request if the title field is not empty
            if !title.isEmpty{
                self.addPassportRequest(_url: "http://lenczes.edumedia.ca/mad9137/final_api/passport/create/?data=", formValues: values)
                print("VALUES: \(values)")
            }
        }
        
        
    }
    
    // to allow the user to press the return key to finish editing we implement this function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passportTitleTextField.resignFirstResponder()
        passportInfoTextView.resignFirstResponder()
        return false
    }
    
    // to allow the user to finish editing by pressing outside the text field we implement this method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // mehtod to craeate an add parrport request
    func addPassportRequest(_url: String, formValues: [[String:String]]?) {
        // if there are params lets chain them onto the end of the url
        var json = ""
        // check if params exist and then lets loop through them and chain them onto the  url as the data params
        if let params = formValues {
            json += "{" // add the opening curly brace
            for (index, value) in params.enumerated() {
                if let key = value.keys.first, let input = value.values.first {
                    // check to make sure if we are not on the last iteration of the loop
                    // so we do not add a comma at the end of the json and then also
                    // make sure to add quotations using \" \"
                    json += index < params.count - 1 ? "\"\(key)\":\"\(input)\", " :"\"\(key)\":\"\(input)\""
                    
                }
            }
            json += "}" // add closing brace
        }
        // now encode the payload becuase certain characters are illegal in the URL init(string)
        // operation we have to use the funciton of addingPercentEncoding to allow our URL to be legal
        let encodedPayload = json.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        print(encodedPayload)
        
        // Create the URLSession object that will be used to make the requests
        let mySession: URLSession = URLSession.shared
        
        // Write a url using the currentID to request the image data
        let passportRequestUrl: URL = URL(string: "\(_url)\(encodedPayload)")!
        
        // Create the request object and pass in your url
        var passportRequest: URLRequest = URLRequest(url: passportRequestUrl)
        
        // add my credentials to the URL request object
        passportRequest.addValue("rach0022", forHTTPHeaderField: "my-authentication")
        
        // Make the specific task from the session by passing in your image request, and the function that will be use to handle the image request
        let passportTask = mySession.dataTask(with: passportRequest, completionHandler: self.addPassportRequestTask )
        
        // Tell the image task to run
        passportTask.resume()
        
    }
    
    // method to run the addPassportRequestTask
    func addPassportRequestTask(serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        if let error = serverError {
            // Send en empty string as the data, and the error to the callback function
            print("PASSPORT CREATION ERROR: " + error.localizedDescription)
            // how to show the alert must implement on main thread so we need to modify the error callback
//            // Create a new UIAlertController object with a custom title and message
//            let myAlert:UIAlertController = UIAlertController(title: "Passport Creation Fail", message: "PASSPORT CREATION ERROR: \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
//
//            // Create an 'OK' Button to close the alert
//            let myAction:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
//
//            // Add the Button to the Alert
//            myAlert.addAction(myAction)
//
//            // Show the alert
//            self.present(myAlert, animated: true, completion: nil)
            
            // call our async acll back with the error
            self.asyncCreatePassportCallback(responseString: "", error: error.localizedDescription)
        }else{
            // if no error was generated that means we have a response that we will stringify into
            // our jsonResponseObject and call our asyncronous callback
            let response = String(data: serverData!, encoding: .utf8)!
            self.asyncCreatePassportCallback(responseString: response as String, error: nil)
            
        }
    }
    
    // asyncronus callback for the addPassportRequestTask
    func asyncCreatePassportCallback(responseString: String, error: String?){
        // if the server request generate an error than lets handle it
        if let err = error  {
            print("Error from API: \(err)")
        } else {
            print("Response Successful from the API" + responseString)
        }
        
        // now that we successfully know our request went through lets send the user back to the main view controller
        DispatchQueue.main.async(){
            // pop to root view controller
            self.navigationController?.popToRootViewController(animated: true)
        }
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
