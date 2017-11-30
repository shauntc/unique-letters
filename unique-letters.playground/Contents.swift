//: Letter Removals
import UIKit

let kMininumCharacters = 50
var str = "If you want to jumpstart the process of talking to us about this role, here’s a little challenge: write a program that outputs the largest unique set of characters that can be removed from this paragraph without letting its length drop below 50."

var letters = Dictionary<Character, Int>()

func formatLetterString(letterArray:Array<(Character,Int)>) -> String {
    var letterString = String()
    for remainingLetter in letterArray {
        let string = String(format: "%-2d", remainingLetter.1)
        letterString.append("\"\(remainingLetter.0)\":\(string) ")
    }
    return letterString
}

for letter in str {
    guard letters[letter] != nil else {
        letters[letter] = 1
        continue
    }
    letters[letter]! += 1
}

var sortedLetters = letters.sorted { (leftLetter, rightLetter) -> Bool in leftLetter.value < rightLetter.value }
print("[\(formatLetterString(letterArray: sortedLetters))] <- Full Set")

let fullArray = Array(sortedLetters)

var numChars = 0
while (!sortedLetters.isEmpty) {
    if let largestValue = sortedLetters.popLast() {
        numChars += largestValue.value
    } else { break }
    if(numChars >= kMininumCharacters) {
        break
    }
}

print("[\(formatLetterString(letterArray: sortedLetters.reversed()))] <- Simplest Solution  \(sortedLetters.count) Letters Removed (keep letters with the highest count until it is >=50)")

var viableLetterSets = Array<Array<(Character,Int)>>()
var minRemaining = letters.count - sortedLetters.count

func checkViableRemovals(letterSet:Array<(Character,Int)>, numChars:Int, numRemaining:Int) -> Bool {
    if(numRemaining > minRemaining || letterSet.isEmpty) { return false }
    if(numChars >= kMininumCharacters && !letterSet.isEmpty) {
        viableLetterSets.append(letterSet)
        return true
    }
    
    for letter in letterSet {
        let nextArray = letterSet.filter({ (filterValue) -> Bool in filterValue.0 != letter.0 })
        if !checkViableRemovals(letterSet: nextArray, numChars:(numChars + letter.1), numRemaining:(numRemaining + 1) ) { return false }
    }
    return false
}

checkViableRemovals(letterSet: fullArray.reversed(), numChars: 0, numRemaining: 0)
print("\n\(viableLetterSets.count) Possible removable letter sets with the minimum remaining:")
for viableSet in viableLetterSets {
    print("[\(formatLetterString(letterArray: viableSet))]  \(viableSet.count) Letters Removed")
}

