import MapKit



class MusicAnnotation: NSObject, Decodable, MKAnnotation{

    
    var genre: Genre = .hiphop
    var title: String? = ""
    var subtitle: String? = ""
    
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0

    
    @objc dynamic var coordinate: CLLocationCoordinate2D{
        get{
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set{
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
}
