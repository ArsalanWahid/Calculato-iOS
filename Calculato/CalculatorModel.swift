//
//  CalculatorModel.swift
//  calcualtor
//
//  Created by Arsalan Wahid Asghar on 1/1/18.
//  Copyright © 2018 ASGHARS. All rights reserved.
//

import Foundation

//Handles all the calcualtion
//automatic initializers
//passed around by copying them not in the heap
struct calculatorBrain{

    //MARK:- Properties
    private enum Operations{
        case unaryOperation((Double)->Double) //take a double returns a double
        case binaryOperation((Double,Double)-> Double) //takes two double and returns a double
        case constants(Double)
        case ac
        case equals
        case dot

    }

    //create object for the pendingBinaryOperation
    private var pendingOperation: pendingBinaryOperation?

    //create object for pendingFloat conversion
    private var convertToFloat : pendingFloatConversion?

    //For internal result processing
    private var accumilator: Double?

    private var operation = [
        "+/-":Operations.unaryOperation({-$0}),
        "AC":Operations.ac,
        "=": Operations.equals,
        "x":Operations.binaryOperation({$0 * $1}),
        "-":Operations.binaryOperation({$0 - $1}),
        "+":Operations.binaryOperation({$0 + $1}),
        "/":Operations.binaryOperation({$0 / $1}),
        ".":Operations.dot

    ]


    mutating func performOperation(_ symbol: String) {
        // hanle uniary opeation
        // handle constants
        // handle binary opeation
        if let operation = operation[symbol]{
            switch operation {
            case .constants(let value):
                accumilator = value
            case .unaryOperation(let function):
                if accumilator != nil{
                    accumilator = function(accumilator!)
                }
            case .binaryOperation(let function):
                if accumilator != nil{
                    pendingOperation = pendingBinaryOperation(function: function, firstOpearand: accumilator!) //remembers function and first operand
                    accumilator = nil // to allow second opearnd
                }
            case .ac:
                accumilator = 0.0
            case .equals:
                performOpearation()
            case .dot :
                if accumilator != nil{
                    convertToFloat = pendingFloatConversion(firstoperand: accumilator!)
                    accumilator = nil
                    makeFloat()
                }
            }

        }
    }

    //The brain calculates the result and should be read only
    var result : Double? {
        get{
            return accumilator
        }
    }

    //struct to hold data while we get the second operand from the user
    private struct pendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOpearand:Double

        func performOperation(with secondOperand:Double) -> Double{
            return function(firstOpearand,secondOperand)
        }
    }

    //store the value of the first opeand
    private struct pendingFloatConversion{
        let firstoperand:Double
        func makeFloat(_ secondOperand: Double) ->Double{
            return Double(String(Int(firstoperand)) + "." + String(Int(secondOperand)))!
        }
    }


    //Equates the values based on the given funtion
    private mutating func performOpearation(){
        if pendingOperation != nil && accumilator != nil{
            accumilator = pendingOperation!.performOperation(with: accumilator!)
            pendingOperation = nil
        }
    }


    private mutating func makeFloat(){
        if accumilator != nil && convertToFloat != nil{
            accumilator = convertToFloat?.makeFloat(accumilator!)
            convertToFloat = nil
            //print("The value of the accumilator \(accumilator!)")
        }

    }

    //to perform opeation we need operands mutating is used as strcut by default dont allow changes in its peroperties
    mutating func setOperand(_ operand: Double){
        accumilator = operand
    }

}
