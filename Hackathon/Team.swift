//
//  Team.swift
//  Hackathon
//
//  Created by John Gallaugher on 11/20/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class Team {
    var teamName: String
    var university: String
    var coordinate: CLLocationCoordinate2D
    var projectName: String
    var projectDescription: String
    var postingUserID: String
    var createdOn: String
    var documentID: String
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var dictionary: [String: Any] {
        return ["teamName": teamName, "university": university, "latitude": latitude, "longitude": longitude, "projectName": projectName, "projectDescription": projectDescription, "postingUserID": postingUserID, "createdOn": createdOn]
    }
    
    init(teamName: String, university: String, coordinate: CLLocationCoordinate2D, projectName: String, projectDescription: String, postingUserID: String, createdOn: String, documentID: String) {
        self.teamName = teamName
        self.university = university
        self.coordinate = coordinate
        self.projectName = projectName
        self.projectDescription = projectDescription
        self.postingUserID = postingUserID
        self.createdOn = createdOn
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(teamName: "", university: "", coordinate: CLLocationCoordinate2D(), projectName: "", projectDescription: "", postingUserID: "", createdOn: "", documentID: "")
    }
    
    // NOTE: If you keep the same programming conventions (e.g. a calculated property .dictionary that converts class properties to String: Any pairs, the name of the document stored in the class as .documentID) then the only thing you'll need to change is the document path (i.e. the lines containing "spots" below.
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("teams").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will creat a new ID for us
            ref = db.collection("teams").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
    
}
