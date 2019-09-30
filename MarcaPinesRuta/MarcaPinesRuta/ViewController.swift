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
            
//            locInicial = CLLocation(latitude: (manager.location?.coordinate.latitude)!,longitude: (manager.location?.coordinate.longitude)!)
      //      centerMapOnLocation(location: manager.location!)
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
        
       // coordenadas.append(CLLocationCoordinate2DMake((manager.location?.coordinate.latitude)!, (manager.location?.coordinate.longitude)!))
        
        if contador == false{
      locInicial = CLLocation(latitude: (manager.location?.coordinate.latitude)!,longitude: (manager.location?.coordinate.longitude)!)
            contador = true
        }
      //  var contador = 0, distancia:  Double = 0.0
      //  let locInicial = CLLocation(latitude: 0,longitude: 0)
       var tmpDistancia:  Double = 0.0
        
        let locActual = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        
        tmpDistancia = Double(locActual.distance(from: locInicial ))
       
        // tmpDistancia = (tmpDistancia * 1000).rounded() / 1000
                       distancia += tmpDistancia
     
            let pin = MKPointAnnotation()
                     // pin.title = "\(manager.location!.coordinate.latitude)" + ", " + "\(manager.location!.coordinate.longitude)"
        pin.title = String(format: "%.1f", distancia)
                      pin.subtitle = "\(distancia)"
        pin.coordinate = CLLocationCoordinate2DMake((manager.location?.coordinate.latitude)!, (manager.location?.coordinate.longitude)!)
        
           //  pins2 += pin
        
   /*     let pins = coordenadas.map{ (coordinate) -> MKPointAnnotation in
        
            if contador == 0{
                distancia = 0
                locInicial = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
            else{
                let locActual = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                tmpDistancia = Double(locActual.distance(from: locInicial ))
                tmpDistancia = (tmpDistancia * 100).rounded() / 100
                distancia += tmpDistancia
            }
            
            let pin = MKPointAnnotation()
           // pin.title = "\(manager.location!.coordinate.latitude)" + ", " + "\(manager.location!.coordinate.longitude)"
            pin.title = "\(distancia)"
            pin.subtitle = "\(distancia)"
            pin.coordinate = coordinate
            
            contador += 1
            return pin
        }*/
       
         centerMapOnLocation(location: manager.location!)
        
        //mapa.addAnnotations(pins)
       mapa.addAnnotation(pin)
        
        locInicial = locActual
        
       /* let span = MKCoordinateSpan(latitudeDelta: 0.500, longitudeDelta: 0.500)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!), span: span)
        mapa.setRegion(region, animated: true)*/
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
    
   let regionRadius: CLLocationDistance = 200
    
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

