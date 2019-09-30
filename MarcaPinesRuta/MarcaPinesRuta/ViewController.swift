//
//  ViewController.swift
//  MarcaPinesRuta
//
//  Created by jesus serrano on 9/22/19.
//  Copyright © 2019 gezuzm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet var mapa: MKMapView!
    @IBOutlet var selectorTipoMapa: UISegmentedControl!
    
    
    private let manejador = CLLocationManager()
    
    var coordenadas = Array<CLLocationCoordinate2D>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        manejador.distanceFilter = 50
        
        selectorTipoMapa.selectedSegmentIndex = 0
        
       
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse
        {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    
    var locInicial = CLLocation()
    var contador = false
    var distancia: Double = 0.0
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador == false{
      locInicial = CLLocation(latitude: (manager.location?.coordinate.latitude)!,longitude: (manager.location?.coordinate.longitude)!)
            contador = true
        }
   
       var tmpDistancia:  Double = 0.0
        
        let locActual = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        
        tmpDistancia = Double(locActual.distance(from: locInicial ))
       
        distancia += tmpDistancia
     
        let pin = MKPointAnnotation()
        
        pin.title = "(" + "\((manager.location?.coordinate.latitude)!)" + ", " + "\( (manager.location?.coordinate.longitude)!)"
        pin.subtitle = "distancia: " + String(format: "%.1f", distancia)            //"\(distancia)"
        pin.coordinate = CLLocationCoordinate2DMake((manager.location?.coordinate.latitude)!, (manager.location?.coordinate.longitude)!)
        
         centerMapOnLocation(location: manager.location!)
        
       mapa.addAnnotation(pin)
        
        locInicial = locActual
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "ERROR", message: "error \(error.localizedDescription)", preferredStyle:  .alert)
        let accionOK = UIAlertAction(title: "OK", style: .default, handler: {
            accion in
            //..
        })
        
        alerta.addAction(accionOK)
        self.present(alerta, animated: true, completion: nil)
    }
    
   let regionRadius: CLLocationDistance = 300
    
   func centerMapOnLocation(location: CLLocation)
   {
    let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                              latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
     mapa.setRegion(coordinateRegion, animated: true)
   }

    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
    
        switch selectorTipoMapa.selectedSegmentIndex
        {
            case 0:
                mapa.mapType = .standard
            case 1:
                    mapa.mapType = .satellite
            case 2:
                mapa.mapType = .hybrid
            
            default:
                      mapa.mapType = .standard
        }
    }
    
}

