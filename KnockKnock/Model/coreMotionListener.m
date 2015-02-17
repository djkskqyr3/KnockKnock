//
//  coreMotionListener.m
//  LocaleNatives
//
//  Created by Stephen Chan on 12/31/13.
//  Copyright (c) 2013 Stephen Chan. All rights reserved.
//

#import "coreMotionListener.h"

@interface coreMotionListener()
@property (strong, nonatomic) NSOperationQueue *deviceMeasurementsQueue;
@property (strong, readwrite) NSMutableArray *deviceMotionArray;

@end

@implementation coreMotionListener

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.deviceMotionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)collectMotionInformationWithInterval:(int)interval
{
    // starts device motion manager, with interval in ms
    
    // let's get the information all out from the device motion manager at once first
    
    self.measurementInterval = [NSNumber numberWithFloat:(interval / 1000.0)];
    
    if(self.motionManager.deviceMotionAvailable){
        float intervalInMs = (interval / 1000);
        self.motionManager.deviceMotionUpdateInterval = intervalInMs;
        
        [self.motionManager startDeviceMotionUpdatesToQueue:self.deviceMeasurementsQueue withHandler:^(CMDeviceMotion *deviceMeasurementData, NSError *error){

            [self.delegate motionListener:self didReceiveDeviceMotion:deviceMeasurementData];
            //NSLog(@"%@", deviceMeasurementData);
        }];
    }
}

- (void)stopCollectingMotionInformation
{
    [self.motionManager stopDeviceMotionUpdates];
}

-(CMMotionManager *)motionManager
{
    if (!_motionManager) _motionManager = [[CMMotionManager alloc] init];
    return _motionManager;
}

- (NSOperationQueue *)deviceMeasurementsQueue
{
    if (!_deviceMeasurementsQueue) {
        return [NSOperationQueue currentQueue];
    }
    return _deviceMeasurementsQueue;
}

@end
