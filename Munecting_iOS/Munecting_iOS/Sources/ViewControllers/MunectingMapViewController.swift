import UIKit
import MapKit

class MunectingMapViewController: UIViewController {
    
    @IBOutlet var seoulButton: UIButton!
    @IBOutlet var mapkit: MKMapView!
    let locationManager = CLLocationManager()
    var runTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
    let mTimer: Selector = #selector(Tick_TimeConsole) // 위치 확인 타이머

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Munecting Map"
        self.navigationController?.navigationBar.tintColor = UIColor.munectingPurple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seoulButton.layer.cornerRadius = 10
        mapkit.delegate = self
        locationManager.delegate = self
        registerAnnotationViewClasses()
        makeDummyAnnotation()
        

        // 정확도 설정 - 최고로 높은 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터 승인 요구
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
        // 사용자 위치 보기 설정
        mapkit.showsUserLocation = true
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: mTimer, userInfo: nil, repeats: true)
    }
    
    //내 위치로 이동
    @IBAction func tappedMyLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    //서울로 이동
    @IBAction func tappedSeoulButton(_ sender: Any) {
        moveLocation(latitudeValue: 37.5207945, longtudeValue: 127.0204729, delta: 0.01)
    }
    
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
                        music.title = $0.name
                        music.subtitle = $0.artist
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
    
    
    //해당 지역으로 이동
    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue) //위치
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span) //지도 영역의 높이와 너비
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue) //위도 경도와 이를 눌러싼 사각형의 값을 가진 구조체
        mapkit.setRegion(pRegion, animated: true) //MKCoordinateRegion으로 이동
    }
    
    
    //annnotation 생성
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubTitle:String) {
        mapkit.removeAnnotations(mapkit.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mapkit.addAnnotation(annotation)
    }
    
    @objc func Tick_TimeConsole() {
            
        guard let timeInterval = runTimeInterval else { return }
            
        let interval = Date().timeIntervalSinceReferenceDate - timeInterval
            
        if interval < 0.25 { return }
            
        let coordinate = mapkit.centerCoordinate
//        print(coordinate.latitude)
//        print(coordinate.longitude)
            
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        // 지정된 위치의 지오 코드 요청
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let pm: CLPlacemark = placemarks?.first {
                let address: String = "\(pm.country ?? "") \(pm.administrativeArea ?? "") \(pm.locality ?? "") \(pm.subLocality ?? "") \(pm.name ?? "")"

            } else {

            }
        }
        runTimeInterval = nil
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
            music.title = "hello"
            music.subtitle = "world"
            mapkit.addAnnotation(music)
        }
    }
    
    //AnnotationView등록
    private func registerAnnotationViewClasses() {
        mapkit.register(hiphopAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(baladAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(kpopAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapkit.register(MusicClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}

extension MunectingMapViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    //새로운 위치데이터 사용 함수 현재 위치로 이동
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        moveLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longtudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        searchMunectingMapDataWithAPI(x: (pLocation?.coordinate.latitude)!, y: (pLocation?.coordinate.longitude)!, range: 1000)
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
        case .balad:
            return baladAnnotationView(annotation: annotation, reuseIdentifier: baladAnnotationView.ReuseID)
        case .kpop:
            return kpopAnnotationView(annotation: annotation, reuseIdentifier: kpopAnnotationView.ReuseID)
        default:
            return kpopAnnotationView(annotation: annotation, reuseIdentifier: kpopAnnotationView.ReuseID)
        }
    }
}
























