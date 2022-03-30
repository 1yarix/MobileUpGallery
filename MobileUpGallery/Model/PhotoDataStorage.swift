class PhotoDataStorage {
    
    static let shared = PhotoDataStorage()
    
    private(set) var photos: [Photo]
    
    private init() {
        self.photos = VKRequestHandler.getAlbumPhotos()
        filterUrls()
    }
    
    private func filterUrls() {
       photos = photos.map({
           var photo = $0
           photo.sizes = photo.sizes.filter({$0.type == "w"})
           return photo
        })
    }
}
