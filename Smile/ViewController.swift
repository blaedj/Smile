//
//  ViewController.swift
//  Smile
//
//  Created by Blaed Johnston on 9/25/15.
//  Copyright © 2015 Blaed Johnston. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
    }

    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        // do some stuff to get picture from library, then call presentviewcontroller
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func getPic() {
        let types = UIImagePickerController.availableMediaTypesForSourceType(.Camera)!
        let canTakePhotos = types.contains(kUTTypeImage as String)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) && canTakePhotos {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .Camera
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }

    // TODO: fix the positioning of the borders, they are offset; maybe because the image gets scaled?
    // TODO: clear the old borderViews and labels when drawing new ones
    // TODO: maybe remove myImageView and just programmatically add an image view?
    
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let backgroundImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let chosenImage = CIImage(image: info[UIImagePickerControllerEditedImage] as! UIImage)!

        let detector = CIDetector(
                    ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        let faces = detector.featuresInImage(chosenImage, options: [CIDetectorSmile: true]) as! [CIFaceFeature]

        print("faces: \(faces.count)")
        for face in faces {
            
            let frame = CGRect(
                x: face.mouthPosition.x - (0.5 * face.bounds.width), //bounds.origin.x,
                y: face.mouthPosition.y - (0.5 * face.bounds.height),
                width: face.bounds.size.width,
                height: face.bounds.size.height)

            let borderView = UIView(frame: frame )
            borderView.layer.borderWidth = 1
            borderView.layer.borderColor = UIColor.redColor().CGColor
           
            let labelX = borderView.frame.origin.x
            let labelY = borderView.frame.origin.y
            let label = UILabel(frame: CGRectMake(labelX, labelY, face.bounds.size.width, 14))

            print("found smile? \(face.hasSmile ? true : false)")
            label.text = face.hasSmile ? "😀" : "😡"

            self.view.addSubview(label)
            self.view.addSubview(borderView)
        }

        myImageView.image = backgroundImage
        //myImageView.layer.setAffineTransform(CGAffineTransformMakeScale(1, -1))
        //self.view.layer.setAffineTransform(CGAffineTransformMakeScale(1, -1))
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }



}

