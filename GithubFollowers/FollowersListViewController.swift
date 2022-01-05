//
//  FollowersListViewController.swift
//  GithubFollowers
//
//  Created by Shelly Gupta on 12/7/21.
//

import UIKit

private let reuseIdentifier = "cell"

struct FollowerCellModel {
    let title: String
    let imageUrl: String?
    var image: UIImage?
}

class FollowersListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    var dataSource: [FollowerCellModel] = []
//    var result = [UserModel]()
    var result = [UserModel](){
        didSet {
            dataSource = result.customMap { FollowerCellModel(title: $0.login, imageUrl: $0.avatar_url, image: nil)}
            print("hello \(dataSource.customFilter({ $0.title.count > 8}))")
            print("dataHandler \(dataSource)")
        }
    }
    
    
    var imageData: [Data]? = []
    
    // 2nd way to recieve data from vc

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        CustomNotificationCenter.shared.addObserver(self,
                                                    completion: { [weak self] notificationInfo in
                                                        self?.handleData1(notificationInfo)
                                                    },
                                                    name: "first")
//        NotificationCenter.default.addObserver(self, selector: #selector(handleData), name: Notification.Name.didReceiveUserModel, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
//        CustomNotificationCenter.shared.removeObserverForName("first", self)
        print("deinit called")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FollowersListCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "Home"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        downloadImage()
        print(result)
    }
    
    func handleData1(_ notificationInfo: Any?) {
        print("Notification Received")
        if let resultedData = notificationInfo as? [UserModel] {
            self.result = resultedData
            dataSource = result.map { FollowerCellModel(title: $0.login, imageUrl: $0.avatar_url, image: nil)}
            print(dataSource)
        }
    }
    
//    @objc func handleData(_ notification: Notification) {
//        if let resultedData = notification.object as? [UserModel] {
//            self.result = resultedData
//            dataSource = result.map { FollowerCellModel(title: $0.login, imageUrl: $0.avatar_url, image: nil)}
//            print(dataSource)
//        }
//    }
    
//    func didReceiveObject(_ userModel: [UserModel]) {
//        result = userModel
   // }
    
    func downloadImage() {
        dataSource.enumerated().forEach { (index, cellModel) in
            if let urlString = cellModel.imageUrl, let url = URL(string: urlString) {
                //Fetch Image Data
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        self?.dataSource[index].image = image
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                        }
                    }
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FollowersListCollectionViewCell
//        cell.backgroundColor = .blue
        cell.nameLabel.text = dataSource[indexPath.row].title
        if let image = dataSource[indexPath.row].image {
            cell.followersImage.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width / 3.0
        let screenHeight = screenWidth

            return CGSize(width: screenWidth, height: screenHeight)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}
