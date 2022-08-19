//
//  ViewController.swift
//  Project2
//
//  Created by TwoStraws on 13/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!

	var countries = [String]()
	var correctAnswer = 0
	var score = 0
    var isNewRecord = true
    
    var virtualUser = UUID.init().uuidString

	override func viewDidLoad() {
		super.viewDidLoad()

		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1

		button1.layer.borderColor = UIColor.lightGray.cgColor
		button2.layer.borderColor = UIColor.lightGray.cgColor
		button3.layer.borderColor = UIColor.lightGray.cgColor

		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		askQuestion()
	}

	func askQuestion(action: UIAlertAction! = nil) {
		countries.shuffle()

		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)

        correctAnswer = Int.random(in: 0...2)
		title = countries[correctAnswer].uppercased()
	}

    fileprivate func animator(_ sender: UIButton, _ title: String) {
        UIImageView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5,
                            options: [], animations: {
            
            switch title {
                case "Correct":
                    sender.imageView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                case "Wrong":
                sender.imageView?.transform = CGAffineTransform(translationX: 80, y: 0)
                
            default:
                break
            }
            
        }) {
            finished in
            sender.imageView?.transform = .identity
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
		var title: String

		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
            animator(sender, title)
		} else {
			title = "Wrong"
			score -= 1
            animator(sender, title)
		}

		let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
		present(ac, animated: true)
        
        saveScore(score: score)
        
        readScore(score: score)
	}
    
    func saveScore(score: Int) {
        let defaults = UserDefaults.standard
        var usersDict = defaults.object(forKey: "usersDict") as? Dictionary ?? [String:Int]()
        usersDict[virtualUser] = score
        defaults.set(usersDict, forKey: "usersDict")
    }
    
    func readScore(score: Int) {
        let defaults = UserDefaults.standard
        guard let usersDict = defaults.object(forKey: "usersDict") as? Dictionary<String, Int> else { return }

        let sortedKeys = usersDict.sorted {
            (aDic, bDic) -> Bool in
            return aDic.value > bDic.value && aDic.key != virtualUser
        }
        
        guard let scoreSaved = sortedKeys.first?.value else { return }
        
        if isNewRecord && score > scoreSaved {
            isNewRecord = false
            let ac = UIAlertController(title: "Woww..", message: "New record: \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    func getScoreUser(user: String) -> Int {
        let defaults = UserDefaults.standard
        guard let usersDict = defaults.object(forKey: "usersDict") as? Dictionary<String, Int> else { return 0 }
        
        if userExits() {
            guard let scoreSaved = usersDict[user] else { return 0 }
            return scoreSaved
        }
        
        return 0
    }
    
    func userExits() -> Bool {
        let defaults = UserDefaults.standard
        guard let usersDict = defaults.object(forKey: "usersDict") as? Dictionary<String, Int> else { return false }
        return usersDict[virtualUser] != nil
    }

}
