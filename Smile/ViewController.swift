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

    var myImageView: UIImageView = UIImageView()
    var scrollView: UIScrollView = UIScrollView()

    override func viewDidLoad() {
        myImageView = UIImageView(image: UIImage(named: "smile474x474"))
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = myImageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        scrollView.addSubview(myImageView)
        view.addSubview(scrollView)
        view.sendSubviewToBack(scrollView)
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
        myImageView = UIImageView(image: backgroundImage)

        let chosenImage = CIImage(image: info[UIImagePickerControllerEditedImage] as! UIImage)!

        let detector = CIDetector(
                    ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        let faces = detector.featuresInImage(chosenImage, options: [CIDetectorSmile: true]) as! [CIFaceFeature]

        for face in faces {
            let borderView = UIView(frame: face.bounds)
            borderView.layer.borderWidth = 1
            borderView.layer.borderColor = UIColor.redColor().CGColor
           
            let labelX = borderView.frame.origin.x + (borderView.bounds.width / 2.0)
            let labelY = borderView.frame.origin.y + borderView.bounds.height
            let label = UILabel(frame: CGRectMake(labelX, labelY, face.bounds.size.width, 14))
            label.text = face.hasSmile ? "😀" : "😡"

            myImageView.addSubview(label)
            myImageView.addSubview(borderView)
        }
        //let newImageView = UIImageView(
        scrollView.subviews.forEach { subView in
            subView.removeFromSuperview()
        }

        scrollView.addSubview(myImageView)
        scrollView.contentSize.width = myImageView.bounds.size.width * 4.0
        scrollView.contentSize.height = myImageView.bounds.size.height * 4.0
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK Debug methods---------------------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        print("Touch x,y is: \(touch?.locationInView(myImageView).x),\(touch?.locationInView(myImageView).y)")
    }
    
    

}

