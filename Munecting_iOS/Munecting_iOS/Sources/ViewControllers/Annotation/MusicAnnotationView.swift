import MapKit

private let MusicClusterID = "musicCluterID"



//hiphopAnnotationView
class hiphopAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "hiphopAnnotationView"
    
    var miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20)).setImage(#imageLiteral(resourceName: "music"), for: .normal)
 

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.systemRed
        glyphImage = #imageLiteral(resourceName: "music")
    }
}

//rockAnnotationView
class rockAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "rockAnnotationView"
    
    var miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20)).setImage(#imageLiteral(resourceName: "music"), for: .normal)
 

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.black
        glyphImage = #imageLiteral(resourceName: "music")

    }
}

//baladAnnotationView
class baladAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "baladAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.systemGreen
        glyphImage = #imageLiteral(resourceName: "music")
    }
}

//classicAnnotationView
class classicAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "baladAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.systemOrange
        glyphImage = #imageLiteral(resourceName: "music")
    }
}

//popAnnotationView
class popAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "popAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.munectingPurple
        glyphImage = #imageLiteral(resourceName: "music")
    }
}

//bluesAnnotationView
class bluesAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "bluesAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.systemBlue
        glyphImage = #imageLiteral(resourceName: "music")
    }
}

//rnbAnnotationView
class rnbAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "rnbAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.munectingBlue
        glyphImage = #imageLiteral(resourceName: "music")
    }
}

//countryAnnotationView
class countryAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "countryAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.systemYellow
        glyphImage = #imageLiteral(resourceName: "music")
    }
}

//edmAnnotationView
class edmAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "edmAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.lightGray
        glyphImage = #imageLiteral(resourceName: "music")
    }
}



//kpopAnnotationView
class kpopAnnotationView: MKMarkerAnnotationView{
    static let ReuseID = "kpopAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = MusicClusterID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = UIColor.systemPurple
        glyphImage = #imageLiteral(resourceName: "music")

    }
}
