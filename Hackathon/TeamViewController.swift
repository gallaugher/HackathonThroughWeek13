//
//  TeamViewController.swift
//  Hackathon
//
//  Created by John Gallaugher on 11/20/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import UIKit
import GooglePlaces

class TeamViewController: UIViewController {
    @IBOutlet weak var teamNameField: UITextField!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var team: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if team == nil {
            team = Team()
        }
    }
    
    func updateUserInterface() {
        teamNameField.text = team.teamName
        universityField.text = team.university
        projectNameField.text = team.projectName
        descriptionTextView.text = team.projectDescription
    }
    
    func updateDataFromInterface() {
        // If you're reusing this code, the code inside this function should be modified to fit the needs of the specific Interface and Object being used.
        team.teamName = teamNameField.text!
        team.university =  universityField.text!
        team.projectName = projectNameField.text!
        team.projectDescription = descriptionTextView.text
    }
    
    @IBAction func findLocationPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        // When reusing this code, the only changes required may be to spot.saveData (you'll likley have a different object, and it is possible that you might pass in parameters if you're saving to a longer document reference path
        updateDataFromInterface()
        team.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("*** ERROR: Couldn't leave this view controller because data wasn't saved.")
            }
        }
    }
    
}

extension TeamViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        team.university = place.name
        team.coordinate = place.coordinate
        team.projectDescription = "Latitude: \(place.coordinate.latitude)\nLongitude: \(place.coordinate.longitude)"
        universityField.text = team.university
        descriptionTextView.text = team.projectDescription
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
