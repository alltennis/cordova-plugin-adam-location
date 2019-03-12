//
//  BaiduMapLocation.h
//
//  Created by LiuRui on 2017/2/25.
//

#import <Cordova/CDV.h>

#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface BaiduMapLocation : CDVPlugin<BMKMapViewDelegate, BMKLocationManagerDelegate> {
    //BMKLocationService* _locService;
    BMKLocationManager _locationManager;
    BMKGeoCodeSearch* _geoCodeSerch;
    CDVInvokedUrlCommand* _execCommand;
    NSMutableDictionary* _data;
    BOOL _isNeedAddr;
}


- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command;
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;

@end
