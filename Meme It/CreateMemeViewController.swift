//
//  CreateMemeViewController.swift
//  Meme It
//
//  Created by Jonathan Agarrat on 12/3/15.
//  Copyright © 2015 Jenius. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomTextField: UITextField!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Determine if the users device has a camera available
        
        cameraButton.enabled =  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //disable the share button if no image is in the view to share
        shareButton.enabled = selectedImage.image != nil
        
        // Set the text field delegates
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // Remove the border from the text fields
        topTextField.borderStyle = UITextBorderStyle.None
        bottomTextField.borderStyle = UITextBorderStyle.None
        
        // Create a dictionary of attributes to apply to the text fields
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: NSNumber(float: -3.0),
        ]
        
        // Set the attributes of the text field to the our desired style
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        topTextField.text = "TOP"
        bottomTextField.text = "Bottom"
        
        // Set the nav and tool bar background color to match our theme
        navbar.barTintColor = UIColorFromHex(0x61827B, alpha: 1.0)
        
        toolbar.barTintColor = UIColorFromHex(0x61827B, alpha: 1.0)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Before the view appears subscribe to the keyboard notifications
        
        subscribeToKeyboardWillShowNotifications()
        
        subscribeToKeyboardWillHideNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // Before the view disappears unsuscribe to the keyboard notifications
        
        unsubscribeFromKeyboardWilShowNotifications()
        
        unsubscribeFromKeyboardWillHideNotifications()
        
    }
    
    // Responds to the camera button

    @IBAction func takeNewPicture(sender: AnyObject) {
        pickImageFromCamera()
    }
    
    // Responds to the photo album button
    
    @IBAction func choosePhotoFromAlbum(sender: AnyObject) {
        
        pickImageFromAlbum()
        
    }
    
    // Respond to cancel button
    
    @IBAction func cancelNewMeme(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Respond to share button
    @IBAction func shareNewMeme(sender: AnyObject) {
        
        let image = genereateMeme()
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        self.presentViewController(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            
            
            if completed == true {
                
                self.save()
                
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    /* Delegates */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let object = info[UIImagePickerControllerOriginalImage]
        
        let pickedImage = object as! UIImage
        
        self.selectedImage.image = pickedImage
        
        shareButton.enabled = selectedImage.image != nil
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    /* Helper Functions */
    
    func pickImageFromAlbum(){
        
        // Get reference to the Image Picker Controller
        let picker = UIImagePickerController()
        
        // Set the delegate for the picker controller
        picker.delegate = self
        
        // Set the source type to Photo Library
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // Present the Image Picker Controller
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func pickImageFromCamera() {
        
        // Get reference to the Image Picker Controller
        let picker = UIImagePickerController()
        
        // Set the delegate for the picker controller
        picker.delegate = self
        
        // Set the source type to Camera
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        // Present the Image Picker Controller
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardWillShowNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWilShowNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        if self.view.frame.origin.y == 0 && !topTextField.editing {
            
            self.view.frame.origin.y -= getKeyboardHeight(notification)

        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let info = notification.userInfo
        
        let keyboardSize = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        
        let keyboardHeight = keyboardSize.CGRectValue().size.height
        
        return keyboardHeight
    }
    
    func genereateMeme() -> UIImage {
        
        navbar.hidden = true
        toolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        navbar.hidden = false
        toolbar.hidden = false
        
        return image
    }
    
    func save(){
        
        let meme = MemeObject(topText: topTextField.text!, bottomText: bottomTextField.text! , originalImage: self.selectedImage.image!, memedImage: self.genereateMeme())
        
        // Add meme to memes array in App delegate
        let object = UIApplication.sharedApplication().delegate
        
        let appDelegate = object as! AppDelegate
        
        appDelegate.memes.append(meme)
       
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
