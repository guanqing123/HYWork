//
//  TestViewController.h
//  officialDemoLoc
//
//  Created by information on 2019/9/28.
//  Copyright © 2019 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : UIViewController

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

NS_ASSUME_NONNULL_END
