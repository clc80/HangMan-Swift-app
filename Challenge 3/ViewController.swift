//
//  ViewController.swift
//  Challenge 3
//
//  Created by Claudia Contreras on 10/11/17.
//  Copyright © 2017 thecoderpilot. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    //Used to get the words from the file
    var allWords = [String] ()
    //Used to keep the letters entered by the user
    var usedLetters = [String] ()
    //Used to get the letters in the word, might not need if I used the contains function.
    var lettersInWord = [String]()
    //the word for the game
    var wordToGuess: String = ""
    //copy of the word to manipulate
    var fakeWord = ""
    //place to add the new index and word found
    var indexToChange = 0
    var letterToAdd = ""
    //Outlet for the Guess Label
    @IBOutlet weak var guessLabel: UILabel!
    //Number of guesses for user
    var guess = 7 {
        didSet {
            guessLabel.text = "Guesses Left: \(guess)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prompt for letter
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // Get the words from the file
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        startGame()
    }

    func startGame(action: UIAlertAction! = nil) {
        //clear out title for the second round
        title?.removeAll()
        //randomize the words in the list
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        wordToGuess = allWords[0]

        usedLetters.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
        //put asterisks instead of letters
        let copyWord = wordToGuess
        var i = 0
        
        while i < copyWord.count {
            fakeWord += "*"
            i += 1
        }
        title = fakeWord
    }
    
    //This is going to check the letter that we got from the user and see if it's in the word
    func submit(answer: String) {
        //convert the letter to lowercase
        //let lowerAnswer = answer.lowercased()
        
        //convert from a String to Character
        let charLetter = Character(answer)
        //Check the word in the function
        if isInWord(word: charLetter) {
            //if it is we want to add it to the word in the title
            title = fakeWord
        } else {
            //if it's not we want to increment the score and add the word to the table
            let stringAnswer = String(answer)
            usedLetters.insert(stringAnswer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func isInWord(word: Character) -> Bool {
        var wordToGuessArray = Array(wordToGuess)
        var fakeWordArray = Array(fakeWord)
        
        if wordToGuess.contains (word) {
                    for _ in wordToGuessArray {
                        if let index = wordToGuessArray.index(of: word) {
                            //change the word in case the same letter appears multiple times
                            wordToGuessArray[index] = "?"
                            //change ** to the right letter
                            fakeWordArray[index] = word
                            //Convert back to string
                            fakeWord = String(fakeWordArray)
                            //update the title
                            title = fakeWord
                        }
            }
        } else {
            guess -= 1
            //pop up an alert if the user runs out of guesses
            if guess == 0 {
                let ac = UIAlertController(title: title, message: "Sorry you did't guess \(wordToGuess).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: startGame))
                present(ac, animated: true)
            }
            return false
        }
        return true
    }
   
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer =  ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedLetters.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedLetters[indexPath.row]
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

