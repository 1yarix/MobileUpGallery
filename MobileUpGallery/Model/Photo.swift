struct Photo: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case date, sizes
    }
    
    var date: Int
    var sizes: [Size]
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
