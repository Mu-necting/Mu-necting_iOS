import MapKit

private let MusicClusterID = "musicCluterID"



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
        markerTintColor = UIColor.systemBlue
        glyphImage = #imageLiteral(resourceName: "music")

    }
}

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
