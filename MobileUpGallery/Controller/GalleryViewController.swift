import UIKit
import SwiftyVK

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        getPhotos()
        setupNavigationBar()
    }
    
    // MARK: NavigationBar config
    private func setupNavigationBar() {
        
        navigationItem.title = "Mobile Up Gallery"
        
        navigationController!.hidesBarsOnSwipe = true
        
        navigationController!.navigationBar.standardAppearance.shadowColor = .systemBackground
        navigationController!.navigationBar.standardAppearance.backgroundColor = .systemBackground
        navigationController!.navigationBar.scrollEdgeAppearance? = navigationController!.navigationBar.standardAppearance
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backButton.tintColor = .label
        navigationItem.backBarButtonItem = backButton
        
        let button = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(logout))
        button.tintColor = .label
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func logout() {
        VK.sessions.default.logOut()        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getPhotos() {
    
        do {
            photos = try PhotoDataHandler.getPhotos()
            
        } catch VKError.api(let error){
            let message = "Код ошибки: \(error.code) \n" + error.message
            Alert.showAlert(title: "Ошибка сервера", message: message, actionToRetry: getPhotos, on: self)
        } catch {}
    }
}
        

// MARK: CollectionView Config
extension GalleryViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        
        if let photo = PhotoDataHandler.loadedPhotos[indexPath.row] {
            cell.imageView.image = photo.image
            return cell
        } else {
            let photoUrl = photos[indexPath.row].sizes[0].url
            let photoDate = photos[indexPath.row].date
        
            ImageDownloader.loadImage(with: photoUrl, into: cell.imageView, completion: { _ in
                PhotoDataHandler.loadedPhotos[indexPath.row] = (photoDate, cell.imageView.image!)
            })
            
            return cell
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let countCells = 2
        let offset: CGFloat = 1.0

        let frameCV = collectionView.frame
        let widhtCell = frameCV.width / CGFloat(countCells)
        let heightCell = widhtCell

        let spacing = CGFloat(countCells + 1) * offset / CGFloat(countCells)
        return CGSize(width: widhtCell - spacing, height: heightCell - (offset * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let photo = PhotoDataHandler.loadedPhotos[indexPath.row] else {
            return
        }
        
        let vc = PhotoViewController(nibName: "PhotoView", bundle: nil)
    
        vc.photo = photo.image
        vc.photoDate = TimeInterval(photo.date)
        
        navigationController!.pushViewController(vc, animated: true)
    }
}
