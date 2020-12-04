# MAD9137 Final - Passport Application in XCODE

## Bugs:
- [x] preform segue to 'ShowPassportTable' does not fire, may have to change logic | SOLUTION: forgot to fire the task off the main thread
- [ ] need to figure out way to change the initial root view of the final project from the splash screen to the table view

## Layout (21 pt)

- [x] create a tableViewController, a tableViewController class file, and assign the class to the tableView in the storyboard (3pt)
- [x] embed a NavigationController in the tableView (1pt)
- [x] give your prototype cell a reuse identifier (1 pt)
- [x] add a barButtonItem to the right-hand side of the navigationItem at the top of the TableViewController (1 pt)
- [x] add a total of three regular viewControllers and three viewController classes (for the SplashViewController, the InfoViewController, and the AddViewController), and assign the viewController classes to the views in the storyboard (9 pt)
- [x] after connecting your segues (see below), add a barButtonItem to the top-right of the navigationItem in your AddViewController, and add a textField, a textView, and two datePickers (5 pt)
- [x] add a textView to the InfoViewController (1 pt)

## Actions, Outlets and Segues (13 pt)

- [x] create a segue from the SplashViewController to the NavigationController and give it an appropriate identifier (2 pt)
- [x] create a segue from the prototype cell in the tableViewController to the InfoViewController and give the segue an appropriate identifier (2 pt)
- [x] create a segue from the tableViewController to the AddViewController and give the segue an appropriate identifier (2 pt)
- [x] connect your "Add" barButtonItem to an action in your PassportTableViewController class (1 pt)
- [x] connect your textView to an outlet in your InfoViewController class (1 pt)
- [x] connect your textField textView and both datePicker objects to outlets in your AddViewController (4 pt)
- [x] connect your "Save" barButtonItem to an action in your AddViewController (1 pt)

## SplashViewController class (3 pt)

- [x] when this viewController loads, it will wait 3 seconds and then call the performSegue(withIdentifier, sender) function to segue to the tableView (3 pt)

## PassportTableView class (60 pt)

- [x] create an appropriate JSON object to hold the JSON data returned from https://lenczes.edumedia.ca/mad9137/final_api/passport/read/ (3 pt)
- [x] in the viewWillAppear(_ animated:Bool) function, make a URLRequest to https://lenczes.edumedia.ca/mad9137/final_api/passport/read/ calling a requestTask upon completion (5 pt)
- [x] within your URLRequest, you must add value to the URL’s header for the key “my-authentication”, and pass in the first 8 characters of your school’s email address (e.g. lenc0001) as the value (3 pt)
- [x] write a requestTask to process the server data and any errors that are received by the server, and send it to your callback function (5 pt)
- [x] write a callback function that will process any errors if they exist and, if they don’t, process the response string from the server and serialize the JSON response in to your JSON object, then tell the tableView to reload the data (7 pt)
- [x] override the tableView functions needed to populate the table with tableView cells, displaying the title stored in the JSON object (10 pt)
- [x] override the tableView function to allow the user to delete a location out of the table, and call a function that will make a URLRequest (3 pt)
- [x] write a function that takes an integer for an id parameter and calls the URL https://lenczes.edumedia.ca/mad9137/final_api/passport/delete/?id= , passing the location’s id to the end of the delete query to delete (6 pt)
- [x] within your URLRequest, you must add value to the URL’s header for the key “my-authentication”, and pass in the first 8 characters of your school’s email address (e.g. lenc0001) as the value (3 pt)
- [x] write a deleteRequestTask to process the server data and any errors that are received by the server, and send it to a deleteCallback function (5 pt)
- [x] write a deleteCallback function that will process any errors if they exist and, if they don’t, tell the tableView to reload its data (4 pt)
- [x] when the user clicks a cell in the table, the prepare( for Segue, sender) must pass the correct dictionary when segueing to the InfoViewController (4 pt)
- [x] the “Add” barButtonItem action must call the performSegue(withIdentifier, sender) function to segue to the AddViewController (2 pt)

## InfoViewController class (25 pt)

- [x] create a dictionary that will hold the location’s JSON object passed from the PassportTableViewController (2 pt)
- [ ] in the viewDidLoad() function, call the URL https://lenczes.edumedia.ca/mad9137/final_api/passport/read/?id=, passing the location’s id to the end of the query (5 pt)
- [ ] within your URLRequest, you must add value to the URL’s header for the key “my-authentication”, and pass in the first 8 characters of your school’s email address (e.g. lenc0001) as the value (3 pt)
- [ ] write a requestTask to process the server data and any errors that are received by the server, and send it to your callback function (5 pt)
- [ ] write a callback function that will process any errors if they exist and, if they don’t, process the response string from the server and serialize the JSON response in to your JSON object, then output the title, id, description, latitude, longitude, arrival, and departure to the textView (10 pt)

## AddViewController class (29 pt)

- [ ] import CoreLocation framework, and create a CLLocationManager object (2 pt)
- [ ] in the touchesBegan function, hide the keyboards (2 pt)
- [ ] “Save” barButtonItem action must hide the keyboards (1 pt)
- [ ] if the textField has text entered in it, the “Save” action will make a URLRequest to the following URI https://lenczes.edumedia.ca/mad9137/final_api/passport/create/?data=, concatenating the outlet’s values converted to a JSON string on to the end of the URL (15 pt)
- [ ] write an addRequestTask to process the server data and any errors that are received by the server, and send it to the addCallback function (5 pt)
- [ ] write an addCallback function that will process any errors if they exist and, if they don’t, tell the navigationController to popToRootViewController (4 pt)

## Quality Control (29 pt)

- [ ] add appropriate constraints to all UI objects in the regular viewControllers (10 pt)
- [ ] application runs without errors (10 pt)
- [ ] code is well-written and commented thoroughly (9 pt)

* Total: 180 pt

## Submission
- [ ] Submit a .zip file of your assignment through Brightspace.
- [ ] Use the following naming convention for submissions:
- [ ] username_assignment-title.zip or for example lenc0001_mid-term.zip
