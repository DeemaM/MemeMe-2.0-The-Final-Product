//
//  ViewController.swift
//  Meme1.0
//
//  Created by Deema  on 12/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    //view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultview()
        cancelAndShare(false)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func defaultview() {
        imagePickerView.image = nil
        setupTextField(textField: textTop,text: "TOP")
        setupTextField(textField: textBottom,text: "Bottom")
        shareButton.isEnabled = false
        textTop.textAlignment = .center
        textBottom.textAlignment = .center

        
    }
    
    //keyboard functions
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if (textBottom.isEditing){
            view.frame.origin.y -= getKeyboardHeight(notification) * (-1)
        }}
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //images methods
    
    func pickAnImage(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true 
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(source: .camera)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(source: .photoLibrary)}
    
    
    
    @IBAction func cancel(_ sender: Any) {
        changesAfterCanceling(textTop, with: "TOP",and: memeTextAttributes)
        changesAfterCanceling(textBottom, with: "BOTTOOM",and: memeTextAttributes)
        imagePickerView.image = nil
        cancelAndShare(false)}
    
    func changesAfterCanceling(_ textField: UITextField, with defaultText: String ,and defaultTextAttributes:[NSAttributedString.Key : Any]){
        textField.defaultTextAttributes = defaultTextAttributes
        textField.textAlignment = .center
        textField.text = defaultText
        textField.delegate = self
    }
    
    func cancelAndShare(_ state:Bool){
        shareButton.isEnabled = state
        cancelButton.isEnabled = state
    }
    
    
    func imagePickerControllerDidCancel(_ _picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)}
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
        cancelAndShare(true)
    }
    
    
    //text methods
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor:UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.0
    ]
    
    func setupTextField(textField: UITextField,text: String) {
        textField.text = text
        textField.delegate = self
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.defaultTextAttributes = memeTextAttributes
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField.text == "BOTTOM" || textField.text == "TOP"{
            textField.text = ""
        }
        cancelAndShare(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    //meme methods
    
    func save() {
        // Create the meme
       let meme = Meme(topTextField: textTop.text!, bottomTextField: textBottom.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)    }
    
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        navbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        navbar.isHidden = false
        
        return memedImage
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let ActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        ActivityViewController.completionWithItemsHandler = { activity, processed, items, error in
            if processed
            {
                //Save the image
                self.save()
                //Dismiss the view controller
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(ActivityViewController, animated: true, completion: nil)
        
    }
    
}




