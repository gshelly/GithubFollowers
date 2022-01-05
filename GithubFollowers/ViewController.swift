//
//  ViewController.swift
//  GithubFollowers
//
//  Created by Shelly Gupta on 12/7/21.
//

import UIKit

protocol FollowersDelegate {
    func didReceiveObject(_ userModel: [UserModel])
}

enum Network {
    case success
    case error(_ errorCode: Int)
}

class ViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    let session = URLSession.shared
    let user = ""
    let baseUrl = "https://api.github.com/users/"
    let endUrl = "/followers"
    let resultType: Network = .success
//    var followerDelegate: FollowersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        searchButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func searchAction(_ sender: Any) {
        guard let userNameText = userName.text else {
            return
        }
        
        if let url = URL(string: baseUrl + userNameText + endUrl) {
            print(url)
            URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                
                if let data = data {
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print(jsonString)
//                    }
                    do {
                        let res = try JSONDecoder().decode([UserModel].self, from: data)
                        DispatchQueue.main.async {
                            self?.showResults(result: res)
                        }

                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    private func showResults(result: [UserModel]) {
        
//        followerDelegate?.didReceiveObject(result)
        let nextVC = FollowersListViewController(nibName: "FollowersListViewController", bundle: Bundle(for: type(of: self)))
        //nextVC.result = result // 1st way to send data
//        nextVC.delegate = self
        self.navigationController?.pushViewController(nextVC, animated: true)
        // 2nd way to send data
//        NotificationCenter.default.post(name: Notification.Name.didReceiveUserModel, object: result)
        CustomNotificationCenter.shared.postNotification(name: "first", notificationInfo: result)
//        if let vc = nextVc1 {
//        present(vc, animated: true) {
//            vc.result = result
//        }
//        }
//        if let vc = presentingViewController as? FollowersListViewController {
//            dismiss(animated: true) {
//                vc.result = result
//            }
//        }

    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchButton.isEnabled  = !(textField.text?.isEmpty ?? true)
    }
}

extension Notification.Name {
    static let didReceiveUserModel = Notification.Name("didReceiveUserModel")
}
