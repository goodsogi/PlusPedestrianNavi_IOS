//
//  IMapRenderer.swift
//  PlusPedestrianNaviIOS
//
//  Created by Jeonggyu Park on 2020/12/30.
//  Copyright © 2020 박정규. All rights reserved.
//

import CoreLocation

protocol IMapRenderer {
    
    
    //***************************************************************************************
    //
    //  Map 공통
    //
    //***************************************************************************************
    
    
    func setMap(map: Any)
    
    
    func createMap()
    
    func setMapPadding(value: Int)
    
    func clearMap(screenType: Int)
    
    func moveMapToLocation(location: CLLocation)
    
    
    //***************************************************************************************
    //
    //  MainFragment
    //
    //***************************************************************************************
    
    
    func showCurrentLocationMarker(currentLocation: CLLocation)
    
    func applyAngleToCurrentLocationMarker(angle: Double)
    
    
    //***************************************************************************************
    //
    //  ChooseOnMapFragment
    //
    //***************************************************************************************
    
    func getMapCenterLatitude()
    
    func getMapCenterLongitude()
    
    
    //***************************************************************************************
    //
    //  PlaceInfoFragment
    //
    //***************************************************************************************
    
    func showPlaceMarker(placePosition: CLLocation)
    
    
    //***************************************************************************************
    //
    //  RouteInfoFragment
    //
    //***************************************************************************************
    
    func showRouteOverlays(directionModel: DirectionModel)
    
    
    //***************************************************************************************
    //
    //  NavigationFragment
    //
    //***************************************************************************************
    
    func showNavigationOverlays()
    
    func showOverview(angle: Double)
    
    func showGeofenceMarker(geofenceModel: GeofenceModel)
    
    func showNavigationMarker(nearestSegmentedRoutePoint: CLLocation)
    
    func updateMapBearingAndZoom(currentGeofenceLocation: CLLocation, nextGeofenceLocation: CLLocation)
    
    func handleExitFromOverview()
    
    //***************************************************************************************
    //
    // SearchNearbyFragment
    //
    //***************************************************************************************
    
    func showSearchNearbyPlaceMarkers()
    
    func enlargeZoomForSearchNearby()
    
    func handleMarkerClick(placeModelOfSelectedMarker: PlaceModel)
    
    func resetSelectedMarkerIcon()
    
    func showProgress(progress: Double)
}
