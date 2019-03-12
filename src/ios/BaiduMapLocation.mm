//
//  BaiduMapLocation.mm
//
//  Created by LiuRui on 2017/2/25.
//

#import "BaiduMapLocation.h"

@implementation BaiduMapLocation

- (void)pluginInitialize
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSString* IOS_KEY = [[plistDic objectForKey:@"BaiduMapLocation"] objectForKey:@"IOS_KEY"];
    

    [[[BMKMapManager alloc] init] start:IOS_KEY generalDelegate:nil];

    _data = [[NSMutableDictionary alloc] init];

    // init _locationManager
    //初始化BMKLocationManager(定位)的实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置BMKLocationService的代理
    _locationManager.delegate = self;

    //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.distanceFilter = [distance.text doubleValue];
    //设定定位精度，默认为 kCLLocationAccuracyBest
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //指定定位是否会被系统自动暂停，默认为NO
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    /**
      是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
      设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
      由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
    */
    _locationManager.allowsBackgroundLocationUpdates = NO;// YES需要项目配置，否则会报错，具体参考开发文档
    /**
      指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
      注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
      后开始计算。
    */
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
    
    _isNeedAddr = YES;

    // init _geoCodeSerch
    _geoCodeSerch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSerch.delegate = self;
}

- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command
{
    _execCommand = command;
    _locationManager.locatingWithReGeocode = _isNeedAddr;
    [_locationManager startUpdatingLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(_execCommand != nil)
    {
        NSDate* time = userLocation.location.timestamp;
        NSNumber* latitude = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];        
        NSNumber* radius = [NSNumber numberWithDouble:userLocation.location.horizontalAccuracy];
        NSString* title = userLocation.title;
        NSString* subtitle = userLocation.subtitle;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [_data setValue:[dateFormatter stringFromDate:time] forKey:@"time"];
        [_data setValue:latitude forKey:@"latitude"];
        [_data setValue:longitude forKey:@"longitude"];        
        [_data setValue:radius forKey:@"radius"];
        [_data setValue:title forKey:@"title"];
        [_data setValue:subtitle forKey:@"subtitle"];

        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        if (latitude!= 0  && longitude!= 0){
            pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        }

        //初始化请求参数类BMKReverseGeoCodeOption的实例
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.location = pt;
        BOOL flag = [_geoCodeSerch reverseGeoCode:reverseGeoCodeOption];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {        

         BMKAddressComponent *component=[[BMKAddressComponent alloc]init];
         component=result.addressDetail;
                  
         NSString* countryCode = component.countryCode;
         NSString* country = component.country;
         //NSString* adCode = component.adCode;
         NSString* city = component.city;
         NSString* district = component.district;
         NSString* streetName = component.streetName;
         NSString* province = component.province;
         NSString* addr = result.address;
         NSString* sematicDescription = result.sematicDescription;
 
        [_data setValue:countryCode forKey:@"countryCode"];
        [_data setValue:country forKey:@"country"];
        //[_data setValue:adCode forKey:@"citycode"];
        [_data setValue:city forKey:@"city"];
        [_data setValue:district forKey:@"district"];
        [_data setValue:streetName forKey:@"street"];
        [_data setValue:province forKey:@"province"];
        [_data setValue:addr forKey:@"addr"];
        [_data setValue:sematicDescription forKey:@"locationDescribe"];

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:_data];
        [result setKeepCallbackAsBool:TRUE];
        [_locationManager stopUpdatingLocation];
        [self.commandDelegate sendPluginResult:result callbackId:_execCommand.callbackId];
        _execCommand = nil;
    }
}

@end
