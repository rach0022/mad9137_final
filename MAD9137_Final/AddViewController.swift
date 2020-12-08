//
//  AddViewController.swift
//  MAD9137_Final
//
//  Created by Ravi Rachamalla on 2020-12-02.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
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
            values.append(["latitude":"0"]) // change later
            values.append(["longitude":"0"]) // change later
            
            // create the passport request if the title field is not empty
            if !title.isEmpty{
                self.addPassportRequest(_url: "http://lenczes.edumedia.ca/mad9137/final_api/passport/create/?data=", formValues: values)
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
        if serverError != nil {
            // Send en empty string as the data, and the error to the callback function
            print("PASSPORT CREATION ERROR: " + serverError!.localizedDescription)
            self.asyncCreatePassportCallback(responseString: "", error: serverError!.localizedDescription)
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
        if error != nil {
            print("Error from API... handle it")
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
