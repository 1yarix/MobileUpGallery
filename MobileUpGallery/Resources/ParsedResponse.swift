struct ParsedResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case count
        case photos = "items"
    }
    
    let count: Int
    let photos: [Photo]
}

struct Photo: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case date
        case photoSizes = "sizes"
    }
    
    var date: Int
    var photoSizes: [Size]
}

struct Size: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case width, height, url, type
    }
    
    var width: Int
    var height: Int
    var url: String
    var type: String
}
