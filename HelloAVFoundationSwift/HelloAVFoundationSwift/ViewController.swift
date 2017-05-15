//
//  ViewController.swift
//  HelloAVFoundationSwift
//
//  Created by 杨晴贺 on 2017/5/15.
//  Copyright © 2017年 Silence. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UITableViewController {

    let speechController = SpeechController()
    var speechString = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        speechController.synthesizer.delegate = self
        speechController.beginConversation()
    }


}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speechString.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.row % 2 == 0 ? "YouCell" : "AVFCell"
        if let cell = tableView .dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BubbleCell {
            cell.messageLabel.text = self.speechString[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        speechString.append(utterance.speechString)
        tableView.reloadData()
        let indexPath = IndexPath.init(row: self.speechString.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
}

