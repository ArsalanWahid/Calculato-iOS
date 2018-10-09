//
//  ViewController.swift
//  calcualtor
//
//  Created by Arsalan Wahid Asghar on 1/1/18.
//  Copyright © 2018 ASGHARS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Properties
    var isUserTyping = false

    //This is just making sure that value returned is Double
    var displayValue : Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    //created brain object here to use its functions
    private var brain = calculatorBrain()


    //MARK:- Outlets
    @IBOutlet weak var display: UILabel!

    //MARK:- Actions
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        //print(digit)
        if sender.tag == 1 {
            print("You pressed 1")
        }

        if isUserTyping{
            display.text = display.text! + digit
        }else{
            display.text = digit
            isUserTyping = true
        }
    }



    //test 56 -opearand x perfrom operation
    //refers to model to do all the calcualtion !!
    @IBAction func operationPressed(_ sender: UIButton) {

        //set the first operad to be used
        if isUserTyping{
            brain.setOperand(displayValue)
            isUserTyping = false
        }

        if let mathematicalSymbol = sender.currentTitle{
            print(mathematicalSymbol)
            brain.performOperation(mathematicalSymbol)
        }
        //check if nil is not recieved
        if let display = brain.result{
            displayValue = display
            print(display)
        }
    }
}
