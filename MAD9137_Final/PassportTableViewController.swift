//
//  PassportTableViewController.swift
//  MAD9137_Final
//
//  Created by Ravi Rachamalla on 2020-12-02.
//

import UIKit

class PassportTableViewController: UITableViewController {
    // The properties of the Passport TableViewController
    // the JSON object we created to hold the response, as its an array that has string pointing
    // to an array of string:Any pairs
    var jsonResponseObject : [String:[[String:Any]]]?
    // The connected outlets for the PassportTableView Controller
    
    // methods for the PassportTableViewController
    // prep the URL request inside the viewWillAppear func so we have the data for
    // when the view loads
    override func viewWillAppear(_ animated: Bool) {
        self.loadPassportData(_url: "https://lenczes.edumedia.ca/mad9137/final_api/passport/read/")
    }
    
    // when calling the view did load crate the table cells based on the jsonResponseObject
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // using the size of the responseJSONArray we can determine the number of cells (rows)
        if let jsonData = self.jsonResponseObject {
            return jsonData.count
        } else {
            return 0
        }
    }
    
    // method to customize the cells that we return
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassportTableCell", for: indexPath) as? PassportTableViewCell

        // Configure the cell... after checking if we have JSONData or not
        if let jsonData = self.jsonResponseObject as [String:[[String:Any]]]? {
            // loop through the jsonData array to access the individual values
            let title = "\(jsonData)"
            let arrival = "arrival"
            let departure = "departure"
            
            if let myCell = cell {
                myCell.cellPassportTitle?.text = title
                myCell.cellPassportArrival?.text = arrival
                myCell.cellPassportArrival?.text = departure
                
            }
            
            // print the json data for now to see what we are working with
            print(jsonData)

        }

        return cell!
    }
    
    // the actions connected to the PassportTableViewController
    @IBAction func addPassportBarButtonAction(_ sender: Any) {
    }
    
    // helper methods for the PAssportTableViewController
    // load passport data will take in the parameter of a string and will run the passportTask
    // the string being the specified url with any query parameters specified
    // based on the PlanetaryAPI iOS app from week 12
    func loadPassportData(_url: String) {
        
        // Create the URLSession object that will be used to make the requests
        let mySession: URLSession = URLSession.shared
        
        // Write a url using the currentID to request the image data
        let passportRequestUrl: URL = URL(string: "\(_url)")!
        
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
        if serverError != nil {
            // Send en empty string as the data, and the error to the callback function
            print("PASSPORT LOADING ERROR: " + serverError!.localizedDescription)
            self.asyncPassportCallback(responseString: "", error: serverError!.localizedDescription)
        }else{
            // if no error was generated that means we have a response that we will stringify into
            // our jsonResponseObject and call our asyncronous callback
            let response = String(data: serverData!, encoding: .utf8)!
            self.asyncPassportCallback(responseString: response as String, error: nil)
            
        }
    }
    
    // function callback for the JSON reponse
    func asyncPassportCallback(responseString: String, error: String?){
        // define the string that we will use for our API response
        var outputString: String?
        
        // if the server request generate an error than lets handle it
        if error != nil {
            print("Error from API... handle it")
        } else {
            print("Response Successful from the API" + responseString)
            outputString = responseString
        }
        
        // now with the output string lets convert it into a JSON object
        if let jsonData: Data = outputString?.data(using: String.Encoding.utf8){
            do {
                // set our jsonResponseObject as a searlized version of the output string
                self.jsonResponseObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:[[String:Any]]]
            }
            // if there are anhy errors converting, send them to the console
            catch let convertError {
                print("Error Converting: \(convertError.localizedDescription)")
            }
        }
        
        // to make any UI changes we must call our callback on the main thread using DispatchQuee.main.async()
        
        DispatchQueue.main.async(){
            // update the UI
            self.tableView.reloadData()
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
