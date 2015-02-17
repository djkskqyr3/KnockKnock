//
//  KKTimeVC.m
//  KnockKnock
//
//  Created by JinJoUn on 1/25/15.
//  Copyright (c) 2015 JamesChan. All rights reserved.
//

#import "KKTimeVC.h"
#import "EFCircularSlider.h"

@interface KKTimeVC ()
{
    EFCircularSlider    *hourSlider;
    
    BOOL                isRunning;
    
    int                 originalValue;
    int                 previousValue;
    int                 currentValue;
    
    NSDate              *pauseStart;
    NSDate              *previousFireDate;
    
    NSTimer             *timeCounter;
}

@property (weak, nonatomic) IBOutlet UILabel    *lblCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel    *lblOriginalTime;
@property (weak, nonatomic) IBOutlet UIButton   *btnPlay;
@property (weak, nonatomic) IBOutlet UIView     *viewTimerBack;

@end

@implementation KKTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    originalValue               = 0;
    previousValue               = 0;
    currentValue                = 0;
    timeCounter                 = nil;
    isRunning                   = NO;
    
    hourSlider                  = [[EFCircularSlider alloc] init];
    hourSlider.frame            = CGRectMake(0, 0, 250, 250);
    hourSlider.center           = CGPointMake(self.viewTimerBack.frame.size.width/2, self.viewTimerBack.frame.size.height/2);
    hourSlider.unfilledColor    = [UIColor colorWithRed:64/255.0f green:75/255.0f blue:97/255.0f alpha:1.0f];
    hourSlider.filledColor      = [UIColor colorWithRed:126/255.0f green:87/255.0f blue:194/255.0f alpha:1.0f];
    hourSlider.lineWidth        = 22;
    hourSlider.snapToLabels     = NO;
    hourSlider.minimumValue     = 0;
    hourSlider.maximumValue     = 60;
    hourSlider.handleType       = CircularSliderHandleTypeBigCircle;
    hourSlider.handleColor      = [UIColor whiteColor];
    [self.viewTimerBack addSubview:hourSlider];
    [hourSlider addTarget:self action:@selector(hourDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hourDidChange:(EFCircularSlider*)slider
{
    int newVal  = (int)slider.currentValue;
    int diff    = newVal - previousValue;
    
    if (diff >= 0)
    {
        if (diff > 30)
        {
            originalValue += (-60 + diff);
        }
        else
        {
            originalValue += diff;
        }
    }
    else
    {
        if (diff < -30)
        {
            originalValue += (60 + diff);
        }
        else
        {
            originalValue += diff;
        }
    }
    
    previousValue = newVal;
    
    if (originalValue < 0)
    {
        originalValue = 0;
        previousValue = 0;
        hourSlider.currentValue = 0;
    }
    
    self.lblOriginalTime.text = [NSString stringWithFormat:@"%02d:%02d", originalValue/60, originalValue%60];
    
    self.lblCurrentTime.text = @"00:00";
    
    currentValue = 0;
    isRunning = NO;
    self.btnPlay.selected = NO;
    
    if (timeCounter)
    {
        [timeCounter invalidate];
        timeCounter = nil;
    }
}

- (void)startTimer
{
    if (timeCounter)
    {
        [self resumeTimer:timeCounter];
    }
    else
    {
        if (originalValue == 0)
            return;
        
        currentValue = originalValue;
        
        self.lblCurrentTime.text = [NSString stringWithFormat:@"%02d:%02d", currentValue/60, currentValue%60];
        
        timeCounter = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    
    self.btnPlay.selected = YES;
    isRunning = YES;
}

- (void)stopTimer
{
    if (timeCounter == nil)
        return;
    
    [self pauseTimer:timeCounter];
    
    self.btnPlay.selected = NO;
    
    isRunning = NO;
}

- (BOOL)isRunning
{
    return isRunning;
}

- (void)onTimer
{
    currentValue --;
    self.lblCurrentTime.text = [NSString stringWithFormat:@"%02d:%02d", currentValue/60, currentValue%60];
    
    if (currentValue == 0)
    {
        [timeCounter invalidate];
        timeCounter = nil;
        
        self.btnPlay.selected = NO;
        
        isRunning = NO;
        
        if ([self.delegate respondsToSelector:@selector(finishedTimer:)])
        {
            [self.delegate finishedTimer:self];
        }
    }
}

- (void) pauseTimer:(NSTimer*)timer
{
    pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    previousFireDate = [timer fireDate];
    [timer setFireDate:[NSDate distantFuture]];
}

- (void) resumeTimer:(NSTimer*)timer
{
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
}

- (IBAction)btnPlay_Action:(UIButton*)sender
{
    if (originalValue == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please set time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    self.btnPlay.selected = !self.btnPlay.selected;
    
    if (self.btnPlay.selected)
    {
        [self startTimer];
    }
    else
    {
        [self stopTimer];
    }
}

@end
