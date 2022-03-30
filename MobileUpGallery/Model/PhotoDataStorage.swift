class PhotoDataStorage {
    
    static let shared = PhotoDataStorage()
    private(set) var photos: [Photo]
    
    init() {
        self.photos = VKRequestHandler.getAlbumPhotos()
        filterUrls()
    }
    
    private func filterUrls() {
       photos = photos.map({
           var photo = $0
           photo.photoSizes = photo.photoSizes.filter({$0.type == "w"})
           return photo
        })
    }
}
