//
//  ViewController.swift
//  iosBeltExam
//
//  Created by Andrew Carver on 1/27/17.
//  Copyright © 2017 Andrew Carver. All rights reserved.
//

import UIKit
import CoreData

class EditNoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!

    var noteToEdit: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = noteToEdit?.name
        textView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let text = textView.text
        if textView.text != "" {
            if noteToEdit != nil {
                noteToEdit?.setValue(text, forKey: "name")
                noteToEdit?.setValue(Date(), forKey: "date")
            } else {
                let noteEntity = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
                noteEntity.setValue(text, forKey: "name")
                noteEntity.setValue(Date(), forKey: "date")
            }
            
            ad.saveContext()
        }
    }

}

