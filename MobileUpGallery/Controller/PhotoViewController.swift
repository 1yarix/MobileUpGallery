import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previewCollectionView: UICollectionView!
    
    var photo: UIImage!
    var photoDate: TimeInterval!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = photo
        scrollView.delegate = self
        previewCollectionView.dataSource = self
        previewCollectionView.delegate = self
        previewCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        title = Utils.formatDate(unformatted: photoDate)

        setupShareButton()
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController!.navigationBar.standardAppearance.shadowColor = .systemGray5;
        navigationController!.navigationBar.scrollEdgeAppearance!.shadowColor = .systemGray5
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController!.navigationBar.standardAppearance.shadowColor = .systemBackground;
        navigationController!.navigationBar.scrollEdgeAppearance?.shadowColor = .systemBackground

        navigationController!.hidesBarsOnSwipe = true
    }
    
    private func setupScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.bouncesZoom = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.5
    }
    
    private func setupShareButton() {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareImage))
        button.tintColor = .label
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        navigationItem.rightBarButtonItem = button
    }
        
   @objc private func shareImage() {
        
       let items: [Any] = [imageView.image!]
       
       let customSavePhotoActivity = CustomSavePhotoActivity()
       let avc = UIActivityViewController(activityItems: items, applicationActivities: [customSavePhotoActivity])
       avc.excludedActivityTypes = [.saveToCameraRoll]
       
       /* Костыли для обхода бага(?) на ios 13-14.4
         https://stackoverflow.com/questions/56903030/
         https://developer.apple.com/forums/thread/119482 */
       
       let fakeViewController = UIViewController()
       
       fakeViewController.modalPresentationStyle = .overFullScreen

       avc.completionWithItemsHandler = { [weak fakeViewController, weak self] activityType, _, _, _ in
           
           if activityType == UIActivity.ActivityType("CustomSavePhotoActivity") {
               
               if customSavePhotoActivity.isComplete {
                   Alert.showAlert(title: "Сохранено", message: "", actionToRetry: nil, on: self!)
               }
               else {
                   Alert.showAlert(title: "Ошибка", message: customSavePhotoActivity.error!.localizedDescription, actionToRetry: nil, on: self!)
               }
           }
           
           if let presentingViewController = fakeViewController?.presentingViewController {
               presentingViewController.dismiss(animated: false, completion: nil)
           } else {
               fakeViewController?.dismiss(animated: false, completion: nil)
           }
       }
       present(fakeViewController, animated: true) { [weak fakeViewController] in
           fakeViewController?.present(avc, animated: true, completion: nil)
       }
   }
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension PhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoDataStorage.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = previewCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryCollectionViewCell
        
        if let photo = PhotoDataStorage.loadedPhotos[indexPath.row] {
            cell.imageView.image = photo.image
            return cell
        } else {
            let photoUrl = PhotoDataStorage.photos[indexPath.row].sizes[0].url
            let photoDate = PhotoDataStorage.photos[indexPath.row].date
        
            ImageDownloader.loadImage(with: photoUrl, into: cell.imageView, completion: { _ in
                PhotoDataStorage.loadedPhotos[indexPath.row] = (photoDate, cell.imageView.image!)
            })
            return cell
        }
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let photo = PhotoDataStorage.loadedPhotos[indexPath.row] else {
            return
        }
        
        imageView.image = photo.image
        title = Utils.formatDate(unformatted: TimeInterval(photo.date))
        
        let cell = previewCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = previewCollectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
}

