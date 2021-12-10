//
//  ViewController.swift
//  Project05
//
//  Created by omari on 8/12/2021.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWord = try? String(contentsOf: startWordsUrl) {
                allWords = startWord.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
      
    }
    
   @objc func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    @objc func promptAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self , weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer : String){
       
        
        let lowerCaseAnswer = answer.lowercased()
        let errorTitle : String
        let errorMessage : String
        
        
        if isSame(word: lowerCaseAnswer) {
          if isPossible(word: lowerCaseAnswer){
            if isOriginal(word: lowerCaseAnswer){
                if isReal(word: lowerCaseAnswer){
                    usedWords.insert(answer.lowercased(), at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                    
                } else {
                   
                    errorTitle = "Word not recognized! or shorter"
                    errorMessage = "You can't just make them up !"
                    showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
                }
            } else {
               
                   errorTitle = "Word already used!"
                   errorMessage = "Be more original!"
                showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
            }
        } else {
           
            guard let title = title else { return }
            errorTitle = "Word not possible!"
            errorMessage = "You can't spell that word from \(title.lowercased())!"
             showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }
        } else {
           
            guard let title = title else { return }
            errorTitle = "Word is the same to \(title.lowercased())"
            errorMessage = "Change it please"
            showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
        }

    }
    
    func showErrorMessage(errorTitle : String , errorMessage: String){
        let av = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
               av.addAction(UIAlertAction(title: "OK", style: .default))
               present(av, animated: true)
    
    }
    
    
    
    func isSame(word: String) -> Bool{
        if title?.lowercased() == word {
            return false
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
     let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspeeledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if (misspeeledRange.location == NSNotFound) && (word.utf16.count >= 3){
            return true
        } else if (misspeeledRange.location != NSNotFound) || (word.utf16.count < 3) {
            return false
        }
//        else if (misspeeledRange.location == NSNotFound) && (word.utf16.count < 3) {
//            return false
//        }
        return false
        
        
    }
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        guard var temporWord = title?.lowercased() else { return false }
        for letter in word {
            if let position = temporWord.firstIndex(of: letter){
                temporWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    

}

