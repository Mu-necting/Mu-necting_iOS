import UIKit
import MapKit

class MunectingMapViewController: UIViewController {
    
    @IBOutlet var seoulButton: UIButton!
    @IBOutlet var mapkit: MKMapView!
    
    let locationManager = CLLocationManager()
    var runTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
    var pLocation: CLLocation?
    let mTimer: Selector = #selector(Tick_TimeConsole) // 위치 확인 타이머
    var isLoadRepeat: Bool = false
    

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapkit()
        self.registerAnnotationViewClasses()
        
        self.makeDummyAnnotation()

        self.seoulButton.layer.cornerRadius = 10
        self.isLoadRepeat = false
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: mTimer, userInfo: nil, repeats: true)
    }
    
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Munecting Map"
        self.navigationController?.navigationBar.tintColor = UIColor.munectingPurple
    }
    
    
    //MARK: 설정 함수
    
    //setMapKit
    func setMapkit(){
        mapkit.delegate = self
        locationManager.delegate = self
        // 정확도 설정 - 최고로 높은 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터 승인 요구
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
        // 사용자 위치 보기 설정
        mapkit.showsUserLocation = true
    }
    
    //AnnotationView등록 함수
    private func registerAnnotationViewClasses() {
        mapkit.register(hiphopAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(rockAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(baladAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(classicAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(popAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapkit.register(bluesAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(rnbAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(countryAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(edmAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(kpopAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapkit.register(MusicClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
 
    //MARK: UIButton IBAction
    
    //내 위치로 이동
    @IBAction func tappedMyLocation(_ sender: Any) {
//        locationManager.startUpdatingLocation()
        moveLocation(latitudeValue: (self.pLocation?.coordinate.latitude)!, longtudeValue: (self.pLocation?.coordinate.longitude)!, delta: 0.01)

    }
    //서울로 이동
    @IBAction func tappedSeoulButton(_ sender: Any) {
        moveLocation(latitudeValue: 37.5207945, longtudeValue: 127.0204729, delta: 0.01)
    }
    
    //MARK: Data 관련 함수
    
    //MunectingMapData with API
    func searchMunectingMapDataWithAPI(x: Double, y: Double, range: Int){
        MunectingMapService.shared.searchMunectingMap(x: x, y: y, range: range, completion: {(networkResult) in
            print("===========munectingMapData In======================")
            switch networkResult {
            case.success(let data):
                if let munectingMapData = data as? [MunectingMapData] {
                    print("===========munectingMapData In======================")
                    print(munectingMapData)
                    munectingMapData.forEach{
                        let lat = $0.pointX
                        let log = $0.pointY
                        let loc = CLLocationCoordinate2DMake(lat, log)
                        let genre: Genre = $0.genre
                        let music: MusicAnnotation = MusicAnnotation()
                        music.coordinate = loc
                        music.genre = genre
                        music.title = "\(genre)"
                        music.subtitle = "Track : \($0.name) Artist : \($0.artist)"
                        self.mapkit.addAnnotation(music)
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr in searchMunectingMapDataWithAPI")
            case .serverErr:
                print("serverErr in searchMunectingMapDataWithAPI")
            case .networkFail:
                print("networkFail in searchMunectingMapDataWithAPI")
            }
        })
    }
    
    //dummyAnnotation 생성 및 등록
    func makeDummyAnnotation(){
        for _ in 0...30{
            let lat = Double.random(in: 37.389829539...37.615316721)
            let log = Double.random(in: 126.636638281...127.1903882771)
            let loc = CLLocationCoordinate2DMake(lat, log)
            let genre: Genre = Genre.allCases.randomElement()!
            let music: MusicAnnotation = MusicAnnotation()
            music.coordinate = loc
            music.genre = genre
            music.title = "\(genre)"
            music.subtitle = "name : Attention Artist : NewJeans"
            mapkit.addAnnotation(music)
        }
    }
    
    //MARK: 기타 함수
    
    //해당 지역으로 이동
    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue) //위치
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span) //지도 영역의 높이와 너비
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue) //위도 경도와 이를 눌러싼 사각형의 값을 가진 구조체
        mapkit.setRegion(pRegion, animated: true) //MKCoordinateRegion으로 이동
    }
    
    //현재 위치 update
    @objc func Tick_TimeConsole() {
        guard let timeInterval = runTimeInterval else { return }
        let interval = Date().timeIntervalSinceReferenceDate - timeInterval
        if interval < 0.25 { return }
        locationManager.startUpdatingLocation()
        runTimeInterval = nil
    }
}

extension MunectingMapViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    //새로운 위치데이터 사용 함수 현재 위치로 이동
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        let pLocation = locations.last
        self.pLocation = locations.last
        if self.isLoadRepeat == false{
            searchMunectingMapDataWithAPI(x: (self.pLocation?.coordinate.latitude)!, y: (self.pLocation?.coordinate.longitude)!, range: 1000000)
            self.isLoadRepeat = true
        }
        locationManager.stopUpdatingLocation()
    }
    
    //지도가 보이는 곳이 달라지면 알리는 함수
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        runTimeInterval = Date().timeIntervalSinceReferenceDate
    }
    
    //AnnotationView 생성
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //                유저의 위치와 annotation이 같다면 return -> 유저의 현재 위치를 띄우기 위해서.
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let annotation = annotation as? MusicAnnotation else {return nil}
        
        switch annotation.genre{
        case .hiphop:
            return hiphopAnnotationView(annotation: annotation, reuseIdentifier: hiphopAnnotationView.ReuseID)
        case .rock:
            return rockAnnotationView(annotation: annotation, reuseIdentifier: rockAnnotationView.ReuseID)
        case .balad:
            return baladAnnotationView(annotation: annotation, reuseIdentifier: baladAnnotationView.ReuseID)
        case .classic:
            return classicAnnotationView(annotation: annotation, reuseIdentifier: classicAnnotationView.ReuseID)
        case .pop:
            return popAnnotationView(annotation: annotation, reuseIdentifier: popAnnotationView.ReuseID)
            
        case .blues:
            return bluesAnnotationView(annotation: annotation, reuseIdentifier: bluesAnnotationView.ReuseID)
        case .rnb:
            return rnbAnnotationView(annotation: annotation, reuseIdentifier: rnbAnnotationView.ReuseID)
        case .country:
            return countryAnnotationView(annotation: annotation, reuseIdentifier: countryAnnotationView.ReuseID)
        case .edm:
            return edmAnnotationView(annotation: annotation, reuseIdentifier: edmAnnotationView.ReuseID)
        case .kpop:
            return kpopAnnotationView(annotation: annotation, reuseIdentifier: kpopAnnotationView.ReuseID)
        }
    }
}

//    //annnotation 생성
//    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubTitle:String) {
//        mapkit.removeAnnotations(mapkit.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
//        annotation.title = strTitle
//        annotation.subtitle = strSubTitle
//        mapkit.addAnnotation(annotation)
//    }






















