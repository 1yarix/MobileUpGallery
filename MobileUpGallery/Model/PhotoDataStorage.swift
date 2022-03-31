class PhotoDataStorage {
        
    private(set) var photos: [Photo]
    
    init() throws {
        self.photos = try VKRequestHandler.getAlbumPhotos()
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
