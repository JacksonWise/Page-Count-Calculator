//
//  ViewController.swift
//  Page Count Calculator Universal
//
//  Created by Jackson Wise and Cherie on 8/27/15.
//  Copyright (c) 2015 Jackson Wise and Cherie. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {

    
    // textfields for the four input areas
    @IBOutlet weak var act2Outlet: UITextField!
    
    @IBOutlet weak var midpointOutlet: UITextField!
    
    @IBOutlet weak var act3Outlet: UITextField!
    
    @IBOutlet weak var fadeoutOutlet: UITextField!
    
    @IBOutlet weak var marqueeTextDisplay: UILabel!
    
    
    // sound for the clapper action
    var clapperSound : AVAudioPlayer?
    
    
    // used to change button and marquee images
    @IBOutlet weak var clapperOutlet: UIButton!
    
    @IBOutlet weak var resetOutlet: UIButton!
    
    @IBOutlet weak var marqueeOutlet: UIImageView!
    
    
    // clapper, marquee and reset images
    let clapClosed = UIImage(named: "clapperboard closed")
    let clapOpen = UIImage(named: "clapperboard open")
    
    let marqueeLit = UIImage(named: "marquee title kerning blue-yellow")
    let marqueeUnlit = UIImage(named: "marquee title kerning blue-white")
    let marqueeLitBlank = UIImage(named: "marquee title blank blue-yellow")
    let marqueeUnlitBlank = UIImage(named: "marquee title blank blue-white")
    
    let resetReady = UIImage(named: "reset green3")
    let resetUsed = UIImage(named: "reset red3")
    
    
    // bool to allow one run before resetting
    var allowAction: Bool = true
    
    
    // numbers used to output results
    var act2Output: Float = 0
    var midpointOutput: Float = 0
    var act3Output: Float = 0
    var fadeoutOutput: Float = 0
    
    
    // responses to page lengths being too short/long, etc.
    var responsePG1 = [ "You've got a great future writing commercials!" ]
    
    var responsePG35_39 = [ "According to the Academy of Motion Picture Arts and Sciences®, a feature film's minimum length is 40 minutes."]
    
    var responsePG80_89 = [ "The shortest Oscar®-winning screenplay was for the 90-minute film, Marty."]
    
    var responsePG200 = [ "At this length, perhaps you should turn your script into a miniseries.",
        "Ever thought about making this a two-parter or a trilogy?",
        "Biblical epics are allowed to run long. Is this a Biblical epic?",
        "If you're trying to outdo The Godfather Part II, keep writing more pages!",
        "Even after it was shortened to 219 minutes, audiences would not sit through Heaven's Gate.",
        "Films based on historical figures can run exceptionally long. Is your script based on a historical figure?",
        "Ever heard of the 873 minute movie Resan (The Journey)? There's a reason.",
        "Even auteur Erich von Stroheim had to shorten his 10+ hour film, Greed, down to 200 minutes.",
        "Andy Warhol's 321 minute film, Sleep, put audiences to sleep.",
        "How long is Bernardo Bertolucci's epic film, 1900? Too long!",
        "Are you trying to surpass Gone with the Wind? Go pages!", ]
    
    
    // changes clapper/reset images, plays sound for action/calculation
    func clapperClosed(){
        
        clapperOutlet.setImage(clapClosed, forState: .Normal)
        
        resetOutlet.setImage(resetReady, forState: .Normal)
        
        clapperSound?.play()
    }
    
    
    // resets everything to clear/beginning
    func clapperOpen(){
        
        clapperOutlet.setImage(clapOpen, forState: .Normal)
        
        marqueeOutlet.image = marqueeUnlit
        
        resetOutlet.setImage(resetUsed, forState: .Normal)
        
        marqueeTextDisplay.text = nil
    }
    
    
    // gives a response if there are too few/many pages, etc.
    func wittyResponse(act4Total: Float)
    {
        if(act4Total == 1){
            
            marqueeOutlet.image = marqueeLitBlank
            
            marqueeTextDisplay.text = responsePG1[0]
        }
            
        else if(act4Total >= 35 && act4Total <= 39 ){
            
            marqueeOutlet.image = marqueeLitBlank
            
            marqueeTextDisplay.text = responsePG35_39[0]
        }
            
        else if(act4Total >= 80 && act4Total <= 89){
            
            marqueeOutlet.image = marqueeLitBlank
            
            marqueeTextDisplay.text = responsePG80_89[0]
        }
            
        else if(act4Total >= 201){
            
            marqueeOutlet.image = marqueeLitBlank
            
            let rand = Int(arc4random_uniform(UInt32(responsePG200.count)))
            
            marqueeTextDisplay.text = responsePG200[rand]
        }
            
        else{
            
            marqueeOutlet.image = marqueeLit
        }
    }
    
    
    // outputs page number results, rounds to one decimal place
    func displayResults(act2: Float, midpoint: Float, act3: Float, fadeout: Float){
    
        act2Outlet.text = (String(format: "%.1f", act2))
        midpointOutlet.text = (String(format: "%.1f", midpoint))
        act3Outlet.text = (String(format: "%.1f", act3))
        fadeoutOutlet.text = (String(format: "%.1f", fadeout))
    }
    
    
    // raises screen in order to see textField while typing
    func textFieldDidBeginEditing(textField: UITextField) {
        
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    @IBAction func clapperButton(sender: AnyObject) {
        
        //only allows one run before needing to press reset button
        if allowAction{
            
            // base variables reset to zero, doesn't continually add to last inputs
            act2Output = 0
            midpointOutput = 0
            act3Output = 0
            fadeoutOutput = 0
            
            
            // take only whole int numbers, does nothing otherwise.
            let intAct2Input: Int? = Int(act2Outlet.text!)
            let intMidpointInput: Int? = Int(midpointOutlet.text!)
            let intAct3Input: Int? = Int(act3Outlet.text!)
            let intFadeoutInput: Int? = Int(fadeoutOutlet.text!)
            
            
            // translate inputs to each display. Uses first box which has a non-zero number
            // sets images for action/calculation
            if ( intAct2Input != nil && intAct2Input != 0){
                
                act2Output = Float(intAct2Input!)

                midpointOutput = act2Output * 2
                act3Output = act2Output * 3
                fadeoutOutput = act2Output * 4
                
                displayResults(act2Output, midpoint: midpointOutput, act3: act3Output, fadeout: fadeoutOutput)

                wittyResponse(fadeoutOutput)
                
                clapperClosed()
                
                allowAction = false
            }
                
            else if ( intMidpointInput != nil && intMidpointInput != 0){
                
                midpointOutput = Float(intMidpointInput!)
                
                act2Output = midpointOutput / 2
                act3Output = midpointOutput * 3 / 2
                fadeoutOutput = midpointOutput * 2

                
                displayResults(act2Output, midpoint: midpointOutput, act3: act3Output, fadeout: fadeoutOutput)
                
                wittyResponse(fadeoutOutput)
                
                clapperClosed()
                
                allowAction = false
            }
                
            else if (intAct3Input != nil && intAct3Input != 0){
                
                act3Output = Float(intAct3Input!)
                
                act2Output = act3Output / 3
                midpointOutput = act3Output * 2 / 3
                fadeoutOutput = act3Output * 4 / 3
                
                displayResults(act2Output, midpoint: midpointOutput, act3: act3Output, fadeout: fadeoutOutput)
                
                wittyResponse(fadeoutOutput)
                
                clapperClosed()
                
                allowAction = false
            }
                
            else if (intFadeoutInput != nil && intFadeoutInput != 0){
                
                fadeoutOutput = Float(intFadeoutInput!)
                
                // sets quarter-length pages just in case
                if( intFadeoutInput! % 4 == 1 || intFadeoutInput! == 1 ){
                    
                    act2Outlet.text = "\(((intFadeoutInput!) / 4) )" + ".25"
                    midpointOutlet.text = "\((intFadeoutInput! / 2 ))" + ".50"
                    act3Outlet.text = "\((intFadeoutInput! * 3 / 4))" + ".75"
                    fadeoutOutlet.text = "\(intFadeoutInput!)" + ".0"
                    
                }
                    
                else{
                    
                    act2Output = fadeoutOutput / 4
                    midpointOutput = fadeoutOutput / 2
                    act3Output = fadeoutOutput * 3 / 4
                    
                    displayResults(act2Output, midpoint: midpointOutput, act3: act3Output, fadeout: fadeoutOutput)
                }
                
                wittyResponse(fadeoutOutput)
                
                clapperClosed()
                
                allowAction = false
            }
            
            else{
                
                act2Outlet.text = nil
                midpointOutlet.text = nil
                act3Outlet.text = nil
                fadeoutOutlet.text = nil
            }
        }
    }

    
    // resets text to nil, resets pics, allows for a new input
    @IBAction func resetButton(sender: AnyObject) {
        
        act2Outlet.text = nil
        midpointOutlet.text = nil
        act3Outlet.text = nil
        fadeoutOutlet.text = nil
        
        clapperOpen()
        
        allowAction = true
    }
    
    
    // sets up audio player for clapper sound
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)

        var audioPlayer:AVAudioPlayer?
        
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        }catch {
            
            print("audioPlayer file error")
        }
        
        return audioPlayer
    }
    
    
    override func viewDidLoad(){

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // code to dismiss the keyboard after tapping screen
        self.act2Outlet.delegate = self
        self.midpointOutlet.delegate = self
        self.act3Outlet.delegate = self
        self.fadeoutOutlet.delegate = self
        
        
        // sets up clapper sound
        if let clapperSound = self.setupAudioPlayerWithFile("ButtonTap", type:"wav") {
            self.clapperSound = clapperSound

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // code to dismiss keyboard after tapping screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}

