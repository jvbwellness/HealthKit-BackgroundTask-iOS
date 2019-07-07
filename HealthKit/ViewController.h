//
//  ViewController.h
//  HealthKit
//
//  Created by Sushma S7works on 13/02/19.
//  Copyright © 2019 Sushma S7works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *dateTxt;
@property (strong, nonatomic) IBOutlet UIButton *showHeakthDataBtn;
@property (strong, nonatomic) IBOutlet UIButton *showWorkOutDateBtn;
@property (strong, nonatomic) IBOutlet UITextField *enterGmailIdTXT;
@property (strong, nonatomic)  UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *sendHealthDateBtn;
@property (strong, nonatomic) NSMutableArray *allDataArr;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property(strong,nonatomic)NSString *StepCountStr,*BodyMassIndexStr,*HeightStr,*HeartRateStr,*BloodGlucoseStr,*ActiveEnergyBurnedStr,*BasalEnergyBurnedStr,*BodyFatTemperatureStr,*OxygenSaturationStr,*RespiratoryRateStr,*BodyTemperatureStr,*BasalBodyTemperatureStr,*SleepAnalysisStr,*workOutStr,*sleepStr;
@property (strong, nonatomic) NSMutableArray *objectsToArray;
@property (strong, nonatomic) NSMutableArray *objectsArrayToArray;
//@property (strong, nonatomic) NSMutableArray *allDataArr;
@property (strong, nonatomic) NSMutableArray *startDate;

@property (strong, nonatomic) NSMutableArray *endDate;
@property (strong, nonatomic) NSMutableArray *deviceType;
@property (strong, nonatomic) NSMutableArray *quantity;
@property (strong, nonatomic)  NSMutableArray *quantityType;
@property (strong, nonatomic) NSMutableDictionary *dict;
@property (strong, nonatomic) NSMutableDictionary *hh;
@property (strong, nonatomic) NSMutableArray* arr;
@property (strong, nonatomic)  NSDate *endDate1 ;
@property (strong, nonatomic)  NSDate *Start1Date ;
@property (strong, nonatomic)  NSDate *finalEndDate;
@property (strong, nonatomic) NSDate *finalStartDate;
@property (strong, nonatomic) NSString *timeZone;
@property (strong, nonatomic)  NSDate *endDateWorkout;
@property (nonatomic, retain) NSData* responseData;

/**
 Background Task Methods.
 */
- (void) startRNBackgroundTask;
- (void) runTaskInKilledState;
@end

