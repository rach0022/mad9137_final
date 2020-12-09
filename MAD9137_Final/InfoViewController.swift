//
//  InfoViewController.swift
//  MAD9137_Final
//
//  Created by Ravi Rachamalla on 2020-12-02.
//

import UIKit
import CoreLocation

class InfoViewController: UIViewController {
    // The properties for the InfoViewController
    var currentPassport : [String: Any]?
    var jsonResponseObject: [String: Any]?
    
    // The outlets for the InfoViewController
    @IBOutlet weak var passportInfoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let passport = self.currentPassport {
            print(passport)
            self.createPassportRequest(_url: "http://lenczes.edumedia.ca/mad9137/final_api/passport/read/?id=", id: passport["id"] as! Int)
        }
    }
    
    // methods for te InfoViewController
    
    func createPassportRequest(_url: String, id: Int) {
        // if there are params lets chain them onto the end of the url
        let newURL = _url + "\(id)"
        
        // Create the URLSession object that will be used to make the requests
        let mySession: URLSession = URLSession.shared
        
        // Write a url using the currentID to request the image data
        let passportRequestUrl: URL = URL(string: "\(newURL)")!
        
        // Create the request object and pass in your url
        var passportRequest: URLRequest = URLRequest(url: passportRequestUrl)
        
        // add my credentials to the URL request object
        passportRequest.addValue("rach0022", forHTTPHeaderField: "my-authentication")
        
        // Make the specific task from the session by passing in your image request, and the function that will be use to handle the image request
        let passportTask = mySession.dataTask(with: passportRequest, completionHandler: self.passportRequestTask )
        
        // Tell the image task to run
        passportTask.resume()
        
    }
    
    // function that will process the request and send off the error or response
    // to our passportCallback function
    func passportRequestTask(serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        if let error = serverError {
            // Send en empty string as the data, and the error to the callback function
            print("PASSPORT \(String(describing: self.currentPassport!["id"])) LOADING ERROR: " + error.localizedDescription)
            self.asyncPassportCallback(responseString: "", error: error.localizedDescription)
        }else{
            // if no error was generated that means we have a response that we will stringify into
            // our jsonResponseObject and call our asyncronous callback
            let response = String(data: serverData!, encoding: .utf8)!
            self.asyncPassportCallback(responseString: response as String, error: nil)
            
        }
    }
    
    // method  callback for the JSON reponse
    func asyncPassportCallback(responseString: String, error: String?){
        // define the string that we will use for our API response
        var outputString: String?
        
        // if the server request generate an error than lets handle it
        if let err = error {
            print("Error from API: \(err)")
        } else {
            print("Response Successful from the API" + responseString)
            outputString = responseString
        }
        
        // now with the output string lets convert it into a JSON object
        if let jsonData: Data = outputString?.data(using: String.Encoding.utf8){
            do {
                // set our jsonResponseObject as a searlized version of the output string
                self.jsonResponseObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]
            }
            // if there are anhy errors converting, send them to the console
            catch let convertError {
                print("Error Converting: \(convertError.localizedDescription)")
            }
        }
        
        // to make any UI changes we must call our callback on the main thread using DispatchQuee.main.async()
        // *** ASK SEB IF I CAN UNWRAP LIKE THIS *********
        DispatchQueue.main.async(){
            // update the UI if we have a JSON response object
            if let jsonResponse = self.jsonResponseObject {
                self.title = jsonResponse["title"] as? String
                self.passportInfoTextView.text =
                    """
                    Description:
                    \(jsonResponse["description"] as! String)
                    Arrival:
                    \(jsonResponse["arrival"] as! String)
                    Departure:
                    \(jsonResponse["departure"] as! String)
                    Latitude:
                    \(jsonResponse["latitude"] as! CLLocationDegrees)
                    Longitutde:
                    \(jsonResponse["longitude"] as! CLLocationDegrees)
                    """
            }
            
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
