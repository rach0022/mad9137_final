//
//  PassportCollectionViewController.swift
//  MAD9137_Final
//
//  Created by Ravi Rachamalla on 2020-12-06.
//

import UIKit
// the reference to our reuseIdentifier for the passport Table Cells
private let reuseIdentifier = "PassportCollectionCell"
private var cellColour: UIColor = UIColor.systemGray5
private var selectedCellColour: UIColor = UIColor.systemBlue

class PassportCollectionViewController: UICollectionViewController {
    // The properties of the Passport CollectionViewController
    // the JSON object we created to hold the response, as its an array that has string pointing
    // to an array of string:Any pairs
    var jsonResponseObject : [String:[[String:Any]]]?
    let mobileBreakpoint: CGFloat = 768 // based on mobile pixel breakpoint
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    // methods for the PassportCollectionViewController
    // prep the URL request inside the viewWillAppear func so we have the data for
    // when the view loads
    override func viewWillAppear(_ animated: Bool) {
        self.createPassportRequest(_url: "http://lenczes.edumedia.ca/mad9137/final_api/passport/read/", id: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // to manually set up the shape of colelction view cells
        // Get a reference of the curernt collectionViewLaytout and cast it as a collectionViewFlowLayout
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // check the size of the device, if we are in mobile portrait or not and set the value of the cell width and height
        // calculated from the device size
        let cellWidth = view.frame.size.width < self.mobileBreakpoint ? view.frame.size.width - 40 : (view.frame.size.width - 40) / 3
        let cellHeight = view.frame.size.width < self.mobileBreakpoint ? cellWidth*0.50 : cellWidth*0.30
        
        // set the size for the cells based on above usign the collectionViewLayout
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        print(cellWidth, cellHeight)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //hard coded as we will always have one JSON response at a time to display
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // using the size of the responseJSONArray we can determine the number of cells (rows)
        if let locations = self.jsonResponseObject?["locations"] {
            return locations.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PassportCollectionViewCell
    
        // Configure the cell... after checking if we have JSONData or not
        if let jsonData = self.jsonResponseObject as [String:[[String:Any]]]? {
            if let locations = jsonData["locations"]{
                // loop through the jsonData array to access the individual values
                let title = locations[indexPath.row]["title"] as? String
                
                if let myCell = cell {
                    myCell.cellPassportTitle?.text = title
                    // set the default cell colour:
                    myCell.contentView.backgroundColor = cellColour
                }
            }
        }
    
        return cell! // have to force unwrap, why? Ask about this.
    }
    
    // override the selection cell methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell!.contentView.backgroundColor = selectedCellColour
        if editBarButtonItem.title == "Info" { // we want to delete the item
            // after checking if we have a jsonResponseObject and the "locations" index we can pass in the id
            // of the passport to the createPassportRequest function with an id
            let row = indexPath.row
            if let jsonData = self.jsonResponseObject as [String:[[String:Any]]]? {
                if let locations = jsonData["locations"]{
                    createPassportRequest(_url: "http://lenczes.edumedia.ca/mad9137/final_api/passport/delete/?id=", id: locations[row]["id"] as? Int)
                }
            }
        } else {
            performSegue(withIdentifier: "ShowPassportInfo", sender: self)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell!.contentView.backgroundColor = cellColour
        
    }


    
    // the actions connected to the PAssportCollectionViewController
    
    @IBAction func addPassportBarButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "ShowAddPassportForm", sender: self)
    }
    // action that will delete the passport item
    @IBAction func deletePassportButtonAction(_ sender: Any) {
        
    }
    
    // this action will alow the user to delete any selected cells
    @IBAction func editBarButtonAction(_ sender: Any) {
        // will change the text of the barButtonItem to info
        // or edit, if text is edit that means we are going to segue
        // if not then we are going to delete the pushed cells
        editBarButtonItem.title = editBarButtonItem.title == "Edit" ? "Info" : "Edit"
    }
    
    // method to prepare for the segure to dequeue the proper cell to the  PassportInfoViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPassportInfo" {
            let nextViewController = segue.destination as? InfoViewController
            
            // set the corresponding passport to the proper passport
            // we have to check if passports and locations exist
            if let passports = self.jsonResponseObject {
                if let locations = passports["locations"] {
                    // get the indexPathRow value to be used to set the corresponding location to the next View controller
                    let indexPath = collectionView.indexPathsForSelectedItems![0]
                    print("we are segueing to passport info")
                    nextViewController?.currentPassport = locations[indexPath.row]
                    
                }
            }
        }
    }
    
    // helper methods for the PAssportCollectionViewController
    // load passport data will take in the parameter of a string and will run the passportTask
    // the string being the specified url with any query parameters specified
    // based on the PlanetaryAPI iOS app from week 12
    func createPassportRequest(_url: String, id: Int?) {
        // if there are params lets chain them onto the end of the url
        let newURL = id != nil ? _url + "\(id!)" : _url
        print(newURL)
        
        // Create the URLSession object that will be used to make the requests
        let mySession: URLSession = URLSession.shared
        
        // Write a url using the currentID to request the image data
        let passportRequestUrl: URL = URL(string: "\(newURL)")!
        
        // Create the request object and pass in your url
        var passportRequest: URLRequest = URLRequest(url: passportRequestUrl)
        
        // add my credentials to the URL request object
        passportRequest.addValue("rach0022", forHTTPHeaderField: "my-authentication")
        
        // Make the specific task from the session by passing in your image request, and the function that will be use to handle the image request
        let passportTask = mySession.dataTask(with: passportRequest, completionHandler: id != nil ? self.deletePassportRequestTask : self.passportRequestTask )
        
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
    
    // method  callback for the JSON reponse
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
            self.collectionView.reloadData()
        }
    }
    
    // method callback to deletePassportRequestTask that is called from the createPassportRequest when an id is supplied
    func deletePassportRequestTask(serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        if serverError != nil {
            // Send en empty string as the data, and the error to the callback function
            print("PASSPORT DELETION ERROR: " + serverError!.localizedDescription)
            self.asyncDeletePassportCallback(responseString: "", error: serverError!.localizedDescription)
        }else{
            // if no error was generated that means we have a response that we will stringify into
            // our jsonResponseObject and call our asyncronous callback
            let response = String(data: serverData!, encoding: .utf8)!
            self.asyncDeletePassportCallback(responseString: response as String, error: nil)
            
        }
    }
    
    // method callback to delete the passport and reload the tableView passport json object
    func asyncDeletePassportCallback(responseString: String, error: String?){
        
        // if the server request generate an error than lets handle it
        if error != nil {
            print("Error from API... handle it")
        } else {
            print("Response Successful from the API" + responseString)
        }
        
        DispatchQueue.main.async(){
            // update the UI
            self.createPassportRequest(_url: "http://lenczes.edumedia.ca/mad9137/final_api/passport/read/", id: nil)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
