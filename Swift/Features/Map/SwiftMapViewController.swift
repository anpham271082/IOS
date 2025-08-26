//
//  SwiftMapViewController.swift
//  project_ios
//
//  Created by An Pham Ngoc on 5/5/23.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import CoreLocation

class SwiftMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
	
	private var mapView: GMSMapView!
	private let locationManager = CLLocationManager()
	
	// Cluster Manager
	private var clusterManager: GMUClusterManager!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		
		// Xin quyền vị trí
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		
		// Khởi tạo camera
		let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
		mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
		mapView.delegate = self
		mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		mapView.isMyLocationEnabled = true
		mapView.settings.compassButton = true
		mapView.settings.myLocationButton = true
		mapView.isTrafficEnabled = true
		applyCustomMapStyle()
		view.addSubview(mapView)
		
		// Setup Cluster Manager
		let iconGenerator = GMUDefaultClusterIconGenerator()
		let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
		let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
		renderer.delegate = self
		clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
		
		// Thêm nhiều điểm vào cluster
		addThousandsOfMarkers()
		
		// Thêm nút focus vị trí
		addFloatingButton()
		
		// Render cluster
		clusterManager.cluster()
		clusterManager.setDelegate(self, mapDelegate: self)
	}
	
	// MARK: - Custom Map Style
	private func applyCustomMapStyle() {
		if let styleURL = Bundle.main.url(forResource: "map_style", withExtension: "json") {
			mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
		}
	}
	
	// MARK: - Add Markers to Cluster
	private func addThousandsOfMarkers() {
		for _ in 0..<1000 {
			let lat = -33.86 + Double.random(in: -0.5...0.5)
			let lng = 151.20 + Double.random(in: -0.5...0.5)
			let item = POIItem(position: CLLocationCoordinate2D(latitude: lat, longitude: lng),
							   name: "Point \(Int.random(in: 1...9999))",
							   strSnippet: "This is a beautiful location!")
			clusterManager.add(item)
		}
	}
	
	// MARK: - Floating Button
	private func addFloatingButton() {
		let button = UIButton(type: .custom)
		button.setImage(UIImage(systemName: "location.fill"), for: .normal)
		button.tintColor = .white
		button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		button.layer.cornerRadius = 28
		button.clipsToBounds = true
		button.frame = CGRect(x: view.frame.width - 76, y: view.frame.height - 120, width: 56, height: 56)
		button.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
		button.addTarget(self, action: #selector(centerOnUser), for: .touchUpInside)
		view.addSubview(button)
	}
	
	@objc private func centerOnUser() {
		if let location = locationManager.location {
			let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14)
			mapView.animate(to: camera)
		}
	}
	
	// MARK: - Location
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			locationManager.startUpdatingLocation()
			mapView.isMyLocationEnabled = true
		}
	}
	
	// MARK: - Custom Info Window
	func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
		let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 100))
		infoView.backgroundColor = UIColor.white
		infoView.layer.cornerRadius = 10
		infoView.layer.borderWidth = 1
		infoView.layer.borderColor = UIColor.systemBlue.cgColor
		infoView.clipsToBounds = true
		
		let titleLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 200, height: 22))
		titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
		titleLabel.textColor = .black
		titleLabel.text = marker.title
		infoView.addSubview(titleLabel)
		
		let snippetLabel = UILabel(frame: CGRect(x: 10, y: 32, width: 200, height: 60))
		snippetLabel.font = UIFont.systemFont(ofSize: 14)
		snippetLabel.textColor = .darkGray
		snippetLabel.numberOfLines = 3
		snippetLabel.text = marker.snippet
		infoView.addSubview(snippetLabel)
		
		return infoView
	}
	
	// MARK: - Cluster Manager Delegate
	func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
		let newCamera = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 2)
		mapView.animate(to: newCamera)
		return true
	}
	
	// MARK: - Cluster Renderer Delegate
	func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
		if let item = marker.userData as? POIItem {
			marker.icon = UIImage(named: "pin_red") // icon cho từng marker
			marker.title = item.name
			marker.snippet = item.strSnippet
		}
	}
}

// MARK: - POIItem class
class POIItem: NSObject, GMUClusterItem {
	var position: CLLocationCoordinate2D
	var name: String
	var strSnippet: String
	
	init(position: CLLocationCoordinate2D, name: String, strSnippet: String) {
		self.position = position
		self.name = name
		self.strSnippet = strSnippet
	}
}
