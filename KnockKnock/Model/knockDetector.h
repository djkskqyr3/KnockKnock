//
//  knockDetector.h
//  LocaleNatives
//
//  Created by Stephen Chan on 4/17/14.
//  Copyright (c) 2014 Stephen Chan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "coreMotionListener.h"

@class knockDetector;

@protocol KnockDetectorDelegate <NSObject>

-(void)detectorDidDetectKnock:(knockDetector *)detector;

@end

@interface knockDetector : NSObject <coreMotionListenerDelegate> {
    CMDeviceMotion *currentDeviceMotion;
    CMDeviceMotion *lastDeviceMotion;
    CMAcceleration lastAccel;
    float jerk;
    float jounce;
    float normedAccel;
    float normedRotation;
    NSTimeInterval lastKnockTime;
    NSTimeInterval lastDoubleKnock;
    float filterConstant;
    UIAccelerationValue x;
    UIAccelerationValue y;
    UIAccelerationValue z;
    UIAccelerationValue lastX;
    UIAccelerationValue lastY;
    UIAccelerationValue lastZ;
    NSNumber *timeFromFirstKnock;
    CMAcceleration gravity;
}

@property (strong, nonatomic) coreMotionListener *listener;
@property (strong, nonatomic) id<KnockDetectorDelegate> delegate;

-(void)motionListener:(coreMotionListener *)listener didReceiveDeviceMotion:(CMDeviceMotion *)deviceMotion;

@end
