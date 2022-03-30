import UIKit
import SwiftyVK

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photosData: [Photo]!
    var downloadedImages: [Int: (date: Int, image: UIImage)] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.photosData = PhotoDataStorage.shared.photos
        
        collectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        setupNavigationBar()
    }
    
    // MARK: NavigationBar config
    private func setupNavigationBar() {
        
        self.navigationItem.title = "Mobile Up Gallery"
        self.navigationController?.navigationBar.shadowImage = UIColor.systemBackground.image()
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        
        self.navigationController?.hidesBarsOnSwipe = true
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = .label
        self.navigationItem.backBarButtonItem = backButton
        
        let button = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logout))
        button.tintColor = .label
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc private func logout() {
        VK.sessions.default.logOut()        
        self.dismiss(animated: true, completion: nil)
    }
}
        

// MARK: CollectionView Config
extension GalleryViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        
        let photoUrl = photosData[indexPath.row].photoSizes[0].url
        let photoDate = photosData[indexPath.row].date
    
        ImageDownloader.loadImage(with: photoUrl, into: cell.imageView, completion: { [weak self] _ in
            self!.downloadedImages[indexPath.row] = (photoDate, cell.imageView.image!)
        })

        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let countCells = 2
        let offset: CGFloat = 2.0

        let frameCV = collectionView.frame
        let widhtCell = frameCV.width / CGFloat(countCells)
        let heightCell = widhtCell

        let spacing = CGFloat(countCells + 1) * offset / CGFloat(countCells)
        return CGSize(width: widhtCell - spacing, height: heightCell - (offset * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoViewController(nibName: "PhotoView", bundle: nil)
        vc.imageToShow = downloadedImages[indexPath.row]?.image
        vc.photoDate = TimeInterval(downloadedImages[indexPath.row]!.date)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
