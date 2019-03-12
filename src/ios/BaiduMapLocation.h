//
//  BaiduMapLocation.h
//
//  Created by LiuRui on 2017/2/25.
//

#import <Cordova/CDV.h>

#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface BaiduMapLocation : CDVPlugin<BMKMapViewDelegate, BMKLocationManagerDelegate> {
    //BMKLocationService* _locService;
    BMKGeoCodeSearch* _geoCodeSerch;
    CDVInvokedUrlCommand* _execCommand;
    NSMutableDictionary* _data;
    BOOL isNeedAddr;
}


- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command;
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;

@end
