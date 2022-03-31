import SwiftyVK

class VKRequestHandler {
    
    static func getAlbumPhotos() throws -> [Photo] {
        
        var photos: [Photo] = []
        var error: VKError?
        
        let group = DispatchGroup()
        group.enter()
        
        VK.API.Photos.get([.ownerId: "-128666765", .albumId: "266276915", .rev: "0"])
            .onSuccess {
                let response = try! JSONDecoder().decode(ParsedResponse.self, from: $0)
                photos = response.photos
                group.leave()
            }
            .onError {
                error = $0
                group.leave()
                
            }
            .send()
        
        group.wait()
        if let error = error {
            throw error
        }
        return photos
    }
}
