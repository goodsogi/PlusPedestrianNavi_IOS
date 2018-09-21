//
//  GoogleMapDrawingManager.swift
//  PlusPedestrianNaviIOS
//
//  Created by 박정규 on 2018. 9. 19..
//  Copyright © 2018년 박정규. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class GoogleMapDrawingManager {
    
    var firstPolyline : GMSPolyline!
    var firstPolylineEdge : GMSPolyline!
    var secondPolyline : GMSPolyline!
    var secondPolylineEdge : GMSPolyline!
    var startMarker: GMSMarker!
    var endMarker: GMSMarker!
    
    var currentLocationMarker:GMSMarker!
    
    var mapView:GMSMapView!
    
    func setMapView(mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    
    func showSelectedPlaceOnMap(selectedPlaceModel:SearchPlaceModel) {
        
        let camera = GMSCameraPosition.camera(withLatitude: selectedPlaceModel.getLat() ?? 0, longitude: selectedPlaceModel.getLng() ?? 0, zoom: 14)
        mapView.camera = camera
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: selectedPlaceModel.getLat() ?? 0, longitude: selectedPlaceModel.getLng() ?? 0)
        marker.title = "selected place marker"
        marker.map = self.mapView
        
        
    }
    
    
    
    func createCurrentLocationMarker() {
        currentLocationMarker = GMSMarker()
        
        currentLocationMarker.position = CLLocationCoordinate2D(latitude: 37.534459, longitude: 126.983314)
        currentLocationMarker.title = "current location marker"
        currentLocationMarker.icon = self.getScaledImage(image: UIImage(named: "current_location_marker.png")!, scaledToSize: CGSize(width: 50.0, height: 50.0))
        currentLocationMarker.map = self.mapView
    }
    
    
    func showFirstCurrentLocationOnMap(userLocation: CLLocation) {
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 14)
        mapView.camera = camera
        
        currentLocationMarker.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude , longitude: userLocation.coordinate.longitude )
        
    }
    
    func clearMap() {
        mapView.clear()
    }
    
    
    func getScaledImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func showFirstRoute(firstDirectionModel:DirectionModel,secondDirectionModel:DirectionModel) {
         removeAllPolylines()
        drawSubPolyline(directionModel: secondDirectionModel)
        drawMainPolyline(directionModel: firstDirectionModel)
    }
    
    func removeAllPolylines() {
        firstPolylineEdge.map = nil
        firstPolyline.map = nil
        secondPolylineEdge.map = nil
        secondPolyline.map = nil
    }
    
    func showSecondRoute(firstDirectionModel:DirectionModel,secondDirectionModel:DirectionModel) {
        removeAllPolylines()
        drawSubPolyline(directionModel: firstDirectionModel)
        drawMainPolyline(directionModel: secondDirectionModel)
        
        
   
    }
    
    
    func drawRouteOnMap(firstDirectionModel:DirectionModel,secondDirectionModel:DirectionModel, isShowSecondRoute:Bool) {
       
        clearMap()
        
        drawStartEndMarker(directionModel: firstDirectionModel)
        
        if(isShowSecondRoute) {
            drawSubPolyline(directionModel:secondDirectionModel)
        }
        
        drawMainPolyline(directionModel: firstDirectionModel)
        zoomMapWithPolyline()
        
        
    }
    
    private func zoomMapWithPolyline() {
        //경로가 모두 표시되게 zoom 조정        
        
        ActionDelayManager.run(seconds: 1) { () -> () in // change 2 to desired number of seconds
            //fit map to markers
            var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(self.startMarker.position)
        bounds = bounds.includingCoordinate(self.endMarker.position)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
            self.mapView.animate(with: update)
        }
    }
    
   
    
    private func drawMainPolyline(directionModel:DirectionModel) {
        //두번째 옵션의 경로 polyline 그림
        let path = getPath(directionModel: directionModel)
        
        firstPolylineEdge = getPolyline(path:path, strokeWidth:9.0, strokeColor: HexColorManager.colorWithHexString(hexString: "0078FF"))
        firstPolylineEdge.map = mapView
        
        firstPolyline = getPolyline(path:path, strokeWidth:6.0, strokeColor: HexColorManager.colorWithHexString(hexString: "32AAFF"))
        firstPolyline.map = mapView
    }
    
    private func drawSubPolyline(directionModel:DirectionModel) {
        //두번째 옵션의 경로 polyline 그림
        let path = getPath(directionModel: directionModel)
        
        secondPolylineEdge = getPolyline(path:path, strokeWidth:9.0, strokeColor: HexColorManager.colorWithHexString(hexString: "B38DAFC0"))
        secondPolylineEdge.map = mapView
            
            secondPolyline = getPolyline(path:path, strokeWidth:6.0, strokeColor: HexColorManager.colorWithHexString(hexString: "B3A3CADE"))
            secondPolyline.map = mapView   
        
    }
            
            
    private func getPolyline(path:GMSMutablePath, strokeWidth:CGFloat, strokeColor:UIColor) -> GMSPolyline{
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = strokeWidth
        polyline.strokeColor = strokeColor
        polyline.geodesic = true
        
        return polyline
    }
    

    private func getPath(directionModel:DirectionModel) -> GMSMutablePath {
        
        let path = GMSMutablePath()
        
        for routePointModel in directionModel.getRoutePointModels()! {
            path.addLatitude(routePointModel.getLat()!, longitude: routePointModel.getLng()!)
        }
        
        return path
    }
    
    private func drawStartEndMarker(directionModel:DirectionModel) {
      
        startMarker = GMSMarker()
        
        startMarker.position = CLLocationCoordinate2D(latitude: directionModel.getRoutePointModels()![0].getLat()!, longitude: directionModel.getRoutePointModels()![0].getLng()!)
        startMarker.title = "start marker"
        startMarker.icon = self.getScaledImage(image: UIImage(named: "start_pin.png")!, scaledToSize: CGSize(width: 50.0, height: 50.0))
        startMarker.map = self.mapView
        
        endMarker = GMSMarker()
        
        endMarker.position = CLLocationCoordinate2D(latitude: directionModel.getRoutePointModels()![directionModel.getRoutePointModels()!.count - 1].getLat()!, longitude: directionModel.getRoutePointModels()![directionModel.getRoutePointModels()!.count - 1].getLng()!)
        endMarker.title = "end marker"
        endMarker.icon = self.getScaledImage(image: UIImage(named: "destination_pin.png")!, scaledToSize: CGSize(width: 50.0, height: 50.0))
        endMarker.map = self.mapView
    }
    
    
}