//
//  MemeGeneratorVC.swift
//  MemeMe1
//
//  Created by Roman Kolodzie on 3/8/16.
//  Copyright © 2016 RomanKolodzie. All rights reserved.
//

import UIKit

class MemeGeneratorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UIToolbar!
    
    // MARK: Text Attributes Dictionary
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        shareButton.enabled = false
        
        //Top Text Field
        initTextField(textFieldTop)
        textFieldTop.text = "TOP"
        
        //Bottom Text Field
        initTextField(textFieldBottom)
        textFieldBottom.text = "BOTTOM"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    // Text field initializing function
    
    func initTextField (textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.Center
    }
    
    //Changing Status Bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // Picker controller source type function
    
    func pickerControllerSource (picker: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = picker
        imagePicker.allowsEditing = true
        return imagePicker
    }
    
    // MARK: IBAction
    
    @IBAction func pickAnImage(sender: AnyObject) {
        presentViewController(pickerControllerSource(UIImagePickerControllerSourceType.PhotoLibrary), animated: true, completion: nil)
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        presentViewController(pickerControllerSource(UIImagePickerControllerSourceType.Camera), animated: true, completion: nil)
    }
    
    @IBAction func saveMeme(sender: AnyObject) {
        let meme = generateMemedImage()
        let activityController = UIActivityViewController.init(activityItems: [meme], applicationActivities: nil)
        
        self.presentViewController(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {
            activity, completed, returnedItems, activityError in
            if completed{
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Save Meme
    
    func generateMemedImage() -> UIImage {
        toolbar.hidden = true
        navbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbar.hidden = false
        navbar.hidden = false
        
        return memedImage
    }
    
    func save() {
        //Create Meme
        let meme = Meme(textTop: textFieldTop.text!, textBottom: textFieldBottom.text!, originalImage: imageView.image, newMemeImage: generateMemedImage())
        
        //Add Created Meme to memes Array in AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    // Image Picker Functions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .ScaleAspectFill
        }
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Text Field Functions
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Keyboard Functions
    
    func keyboardWillShow(notification: NSNotification){
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        if textFieldBottom.editing{
            return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeGeneratorVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeGeneratorVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

