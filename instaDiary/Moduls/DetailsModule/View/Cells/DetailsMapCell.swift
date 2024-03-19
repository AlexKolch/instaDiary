//
//  DetailsMapCell.swift
//  instaDiary
//
//  Created by Алексей Колыченков on 19.03.2024.
//

import UIKit
import MapKit

class DetailsMapCell: UICollectionViewCell {
    static let reuseId = "DetailsMapCell"
    
    lazy var mapView: MKMapView = {
        $0.layer.cornerRadius = 30
        return $0
    }(MKMapView(frame: bounds))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else { return }
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        ///точка на карте
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
}
