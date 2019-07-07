//
//  ViewController.m
//  HealthKit
//
//  Created by Sushma S7works on 13/02/19.
//  Copyright © 2019 Sushma S7works. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>
#import "OMHSerializer.h"
#import "WorkoutActivityConversion.h"

@interface ViewController (){
    NSMutableArray *mutArray;
    NSString *daysString;
    NSMutableArray *sampleStepsArray;
}
@property (nonatomic, retain) HKHealthStore* healthStore;
@end
@implementation ViewController
@synthesize StepCountStr,BodyMassIndexStr,HeightStr,HeartRateStr,BloodGlucoseStr,ActiveEnergyBurnedStr,BasalEnergyBurnedStr,BodyFatTemperatureStr,OxygenSaturationStr,RespiratoryRateStr,BodyTemperatureStr,BasalBodyTemperatureStr,SleepAnalysisStr,workOutStr,allDataArr,sleepStr,spinner;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    daysString = @"";
    //[self login];
   mutArray = [NSMutableArray new];
    sampleStepsArray = [NSMutableArray new];
   // [self queryStepCount];
    NSString *newPINString = [self getRandomPINString:10];
     [self checkHealthStoreAuthorization];
 //   [self getStepCountStr];
    NSTimeZone *tz = NSTimeZone.systemTimeZone;
    NSLog(@"present timezone is:%@",newPINString);
    
     self.dict = [NSMutableDictionary dictionary];
     self.arr = [NSMutableArray array];
     self.hh=[[NSMutableDictionary alloc]init];
     self.startDate=[[NSMutableArray alloc]init];
     self.endDate=[[NSMutableArray alloc]init];
     self.deviceType=[[NSMutableArray alloc]init];
     self.quantity=[[NSMutableArray alloc]init];
     self.quantityType=[[NSMutableArray alloc]init];
    spinner= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // [spinner setCenter:CGPointMake(160,124)];
    spinner=  [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 80, 80)];
    spinner.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    spinner.color = [UIColor whiteColor];
    spinner.layer.cornerRadius = 5;
    spinner.layer.masksToBounds = YES;
    spinner.center=self.view.center;
    
    [self.view addSubview:spinner];
    self.enterGmailIdTXT.delegate=self;
    allDataArr=[[NSMutableArray alloc]init];
    _datePicker=[[UIDatePicker alloc]init];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateTxt setInputView:_datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateTxt setInputAccessoryView:toolBar];
    _datePicker.maximumDate=[NSDate date];
    
    [self.showWorkOutDateBtn setHidden:YES];
    [self.showHeakthDataBtn setHidden:YES];
   
   //  [self checkHealthStoreAuthorization];
    // [self retrieveWorkouts];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerCalled) userInfo:nil repeats:YES];
}
-(void)timerCalled
{
    NSLog(@"Timer Called");
    // Your Code
}
-(void)login{
    self.responseData = [NSMutableData new];
    NSURL *url = [NSURL URLWithString:@"https://app.jvbwellness.com/api/users/login/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *requestData = [@"username=Mohan&password=Health2112" dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    //    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    //    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
    //                                                         options:kNilOptions
    //                                                           error:&err];
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
}
-(void)ShowSelectedDate
{
    [self.startDate removeAllObjects];
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"StepData.json";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    if ([filemgr removeItemAtPath:fileAtPath error: NULL] == YES){
        NSLog (@"Remove successful");
        [allDataArr removeAllObjects];
    }
    else{
        NSLog (@"Remove failed");
    }
    NSString* fileName1 = @"WorkoutData.json";
    NSString* fileAtPath1 = [filePath stringByAppendingPathComponent:fileName1];
    if ([filemgr removeItemAtPath:fileAtPath1 error: NULL] == YES){
        NSLog (@"Remove successful");
        [allDataArr removeAllObjects];
    }
    else{
        NSLog (@"Remove failed");
    }
    // [[Crashlytics sharedInstance]crash];
    self.dateTxt.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:_datePicker.date]];
   // [self retrieveWorkouts];
    
   // [self fetchHourlyStepsWithCompletionHandler:nil];
    // [self retrieveWorkouts2];
    [self.dateTxt resignFirstResponder];
}
- (IBAction)oneDayAction:(UIButton *)sender
{
    daysString = @"oneday";
    [self fetchHourlyStepsWithCompletionHandler:nil];
   // [self retrieveWorkouts1];
}
- (IBAction)oneWeekAction:(UIButton *)sender
{
    daysString = @"oneweek";
    [self fetchHourlyStepsWithCompletionHandler:nil];
  //  [self retrieveWorkouts1];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)sendGmailBtnAction:(id)sender {
    //NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSLog(@"my starts are:%@",self.startDate);
    //    NSLog(@"end date are:%@",self.endDate);
    //    NSLog(@"start date are:%@",self.deviceType);
    //
    //    NSLog(@"start date are:%@",self.quantity);
    //    NSLog(@"start date are:%@",self.quantityType);
    //    NSLog(@"start date are:%@",self.startDate);
    // [self posting];
    
    //[self postStepData];
    //[self postWorkoutData];
  
    if (_dateTxt.text && _dateTxt.text.length > 0)
    {
        if (_enterGmailIdTXT.text && _enterGmailIdTXT.text.length > 0)
        {
            if ([MFMailComposeViewController canSendMail])
            {
                NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString* fileName = @"StepData.json";
                NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
                if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
                    [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
                }
                NSString* WorkoutPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSString* WorkoutName = @"WorkoutData.json";
                NSString* WorkoutatPath = [WorkoutPath stringByAppendingPathComponent:WorkoutName];
                if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
                    [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
                }
                if (![[NSFileManager defaultManager] fileExistsAtPath:WorkoutatPath]) {
                    [[NSFileManager defaultManager] createFileAtPath:WorkoutatPath contents:nil attributes:nil];
                }
                NSError *err;
                [self.StepCountStr writeToFile:fileAtPath atomically:YES];
                [self.workOutStr writeToFile:WorkoutatPath atomically:YES];
                NSString *emailTitle = @"StepCount and Health Data";
                NSString *messageBody = @"Hey, check this out!";
                NSArray *toRecipents = [NSArray arrayWithObject:_enterGmailIdTXT.text];
                MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                mc.mailComposeDelegate = self;
                [mc setSubject:emailTitle];
                [mc setMessageBody:messageBody isHTML:NO];
                [mc setToRecipients:toRecipents];
                //NSMutableArray *mohan=[[NSMutableArray alloc]initWithContentsOfFile:fileAtPath];
                NSData *fileData = [NSData dataWithContentsOfFile:fileAtPath];
                NSData *fileData1 = [NSData dataWithContentsOfFile:WorkoutatPath];
                // Add attachment
                [mc addAttachmentData:fileData mimeType:@"application/json" fileName:@"StepCountData.json"];
                [mc addAttachmentData:fileData1 mimeType:@"application/json" fileName:@"WorkoutData.json"];
                // Present mail view controller on screen
                [self presentViewController:mc animated:YES completion:NULL];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This device cannot send email"message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter a Valid email id"message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter a valid date"
                            message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg1;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg1 =@"Sending Mail is cancelled";
            break;
        case MFMailComposeResultSaved:
            msg1=@"Sending Mail is Saved";
            break;
        case MFMailComposeResultSent:
            msg1 =@"Your Mail has been sent successfully";
            break;
        case MFMailComposeResultFailed:
            msg1 =@"Message sending failed";
            break;
        default:
            msg1 =@"Your Mail is not Sent";
            break;
    }
    UIAlertView *mailResuletAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
    mailResuletAlert.message = msg1;
    mailResuletAlert.title = @"Message";
    [mailResuletAlert addButtonWithTitle:@"OK"];
    [mailResuletAlert show];
    //[mailResuletAlert release];
    [self dismissModalViewControllerAnimated:YES];
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)checkHealthStoreAuthorization
{
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *readDataTypes = [self dataTypesToRead];
        NSSet *writeDataTypes = [self WriteDataTypes];
        if (!self.healthStore) {
            self.healthStore = [[HKHealthStore alloc] init];
        }
        static NSInteger i = 0;
        for (HKObjectType * quantityType in readDataTypes) {
            if ([self.healthStore authorizationStatusForType:quantityType] == HKAuthorizationStatusNotDetermined) {
                [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                    i++;
                    if (!success) {
                        if (error) {
                            NSLog(@"requestAuthorizationToShareTypes error: %@", error);
                        }
                        return;
                    } else {
                        if (i == [readDataTypes count]) {
                            static dispatch_once_t onceToken;
                            dispatch_once(&onceToken, ^{
                                // [self getHeight];
                                // [self getWeight];
                                // [self retrieveWorkouts];
                            });
                        }
                    }
                }];
            }
            else {
                
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]]) {
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex]]) {
                    //[self GetBodyMassIndex];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate]]) {
                    //[self GetRespiratoryRate];
                }
                //                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight]]) {
                //                     [self GetHeight];
                //                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature]]) {
                    //[self GetBodyTemperature];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalBodyTemperature]]) {
                    // [self GetBasalBodyTemperature];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned]]) {
                    // [self GetBasalEnergyBurned];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage]]) {
                    //[self GetBodyFatTemperature];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation]]) {
                    // [self GetOxygenSaturation];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate]]) {
                    //[self GetHeartRate];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose]]) {
                    // [self GetBloodGlucose];
                }
                if ([quantityType isEqual:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalBodyTemperature]]) {
                    // [self GetBasalBodyTemperature];
                }
                if ([quantityType isEqual:[HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis]]) {
                    //[self SleepData];
                }
            }
        }
    }
}
- (NSSet *)dataTypesToRead
{
    HKQuantityType *height = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weight = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *walkingDistance=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *walkingDistance1=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *repository=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    HKQuantityType *bodytemp=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *BasalBodyTemperature = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalBodyTemperature];
    HKQuantityType *bodyMassIndex = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    HKQuantityType *LeanBodyMass = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass];
    HKQuantityType *HeartRate = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKQuantityType *BloodGlucose = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    HKQuantityType *ActiveEnergyBurned = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *BasalEnergyBurned = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    HKQuantityType *BodyFatPercentage = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    HKQuantityType *OxygenSaturation = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation];
    HKCategoryType *SleepAnalysis = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    HKWorkoutType *workouttype = [HKWorkoutType workoutType];
    return [NSSet setWithObjects:height, weight,walkingDistance,walkingDistance1,repository,bodytemp,BasalBodyTemperature,bodyMassIndex,LeanBodyMass,HeartRate,BloodGlucose,ActiveEnergyBurned,BasalEnergyBurned,BodyFatPercentage,OxygenSaturation,SleepAnalysis,workouttype, nil];
}
-(NSSet*)WriteDataTypes{
    HKQuantityType *height = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weight = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *walkingDistance=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *walkingDistance1=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *repository=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierRespiratoryRate];
    HKQuantityType *bodytemp=[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *BasalBodyTemperature = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalBodyTemperature];
    HKQuantityType *bodyMassIndex = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    HKQuantityType *LeanBodyMass = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierLeanBodyMass];
    HKQuantityType *HeartRate = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKQuantityType *BloodGlucose = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    HKQuantityType *ActiveEnergyBurned = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *BasalEnergyBurned = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    HKQuantityType *BodyFatPercentage = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    HKQuantityType *OxygenSaturation = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation];
    HKCategoryType *SleepAnalysis = [HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    HKWorkoutType *workouttype = [HKWorkoutType workoutType];
    return [NSSet setWithObjects:height, weight,walkingDistance,walkingDistance1,repository,bodytemp,BasalBodyTemperature,bodyMassIndex,LeanBodyMass,HeartRate,BloodGlucose,ActiveEnergyBurned,BasalEnergyBurned,BodyFatPercentage,OxygenSaturation,SleepAnalysis,workouttype, nil];
}
-(void)fetchHourlyStepsWithCompletionHandler:(void (^)(NSMutableArray *, NSError *))completionHandler
{
    NSMutableArray *mutArray = [NSMutableArray new];
    // Whatever you need in your case
    HKQuantityType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:type];
    BOOL isActive;
    switch (status) {
        case HKAuthorizationStatusSharingAuthorized:
            isActive = YES;
            break;
        case HKAuthorizationStatusSharingDenied:
            [self showAcessPopup];
            isActive = NO;
            return;
        case HKAuthorizationStatusNotDetermined:
            isActive = NO;
            break;
        default:
            break;
    }
    NSLog(@"STATUS-------%@", isActive ? @"yes" : @"no");
    
    NSDate *newDate = [NSDate new];
    NSDate *startDate = [NSDate new];
    NSDate *EDate = self.datePicker.date;
    NSDate *EDate1 = self.datePicker.date;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'00:00:00'Z'"];
    NSString *edate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    //startDate = [formatter dateFromString:edate];
    startDate = self.datePicker.date;
    NSPredicate *timeInterval;
    if ([daysString isEqualToString:@"oneday"])
    {
        newDate = [startDate dateByAddingTimeInterval:1.0 * 60.0 * 60.0 * 24.0];
        NSDateFormatter *formatter1 = [NSDateFormatter new];
        formatter1.dateFormat = @"yyyy-MM-dd";
        NSString *formatStr = [formatter1 stringFromDate:EDate1];
        NSString *dateStr = [formatter1 stringFromDate:[NSDate date]];
        if ([formatStr isEqualToString:dateStr]) {
            newDate = [NSDate date];
        }
        else{
            newDate = [newDate dateByAddingTimeInterval:-1.0];
        }
        //timeInterval =[HKQuery predicateForSamplesWithStartDate:newDate endDate:[NSDate date] options:HKQueryOptionNone];
        timeInterval =[HKQuery predicateForSamplesWithStartDate:startDate endDate:newDate options:HKQueryOptionNone];
    }
    else{
        newDate = [startDate dateByAddingTimeInterval:-7.0 * 60.0 * 60.0 * 24.0];
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:startDate options:0];
        NSLog(@"nextDate: %@ ...", nextDate);
        timeInterval =[HKQuery predicateForSamplesWithStartDate:newDate endDate:startDate options:HKQueryOptionStrictEndDate];
    }
    
        //strdate  = [strdate a]
//        NSDate *todaydate = [dateFormat1 dateFromString:strToday];
//        NSString *strlastDay = [dateFormat1  stringFromDate:startDate];
//        NSDate *lastDate = [dateFormat1 dateFromString:strlastDay];
    /*
    NSTimeInterval secondsBetween = [newDate timeIntervalSinceDate:[NSDate date]];
    int numberOfDays = secondsBetween / 86400;
    NSLog(@"There are %d days in between the two dates.", numberOfDays);
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:newDate
                                                          toDate:[NSDate date]
                                                         options:0];
    NSLog(@"There are %ld days in between the two dates.", (long)[components day]);
   */
   
    NSDateComponents *intervalComponents = [[NSDateComponents alloc] init];
    intervalComponents.minute = 1;
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:type quantitySamplePredicate:timeInterval options:HKStatisticsOptionSeparateBySource anchorDate:newDate intervalComponents:intervalComponents];
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        [results
         enumerateStatisticsFromDate:newDate
         //toDate:startDate
         toDate:[NSDate date]
         withBlock:^(HKStatistics *result, BOOL *stop) {
             if (!result) {
                 if (completionHandler) {
                     completionHandler(nil, error);
                 }
                 return;
             }
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 [self->spinner startAnimating];                                             }) ;
             HKQuantity *quantity = result.sumQuantity;
             
             NSDate *startDate = result.startDate;
             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
             formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
             NSString *dateString = [formatter stringFromDate:startDate];
             NSString *endDateString=[formatter stringFromDate:result.endDate];
             NSString *quantityString = [NSString stringWithFormat:@"%@",result.quantityType];
             NSString *quantityString1 = [NSString stringWithFormat:@"%@",result.sources];
             
             NSArray* foo = [quantityString1 componentsSeparatedByString: @","];
             NSMutableArray *finalArray = [NSMutableArray new];
             if([foo count]==3){
                 NSString *FirstString = [NSString stringWithFormat:@"%@",[foo objectAtIndex:0]];
                  NSString *SecondString = [NSString stringWithFormat:@"%@",[foo objectAtIndex:1]];
                  NSString *ThirdString = [NSString stringWithFormat:@"%@",[foo objectAtIndex:2]];
                 FirstString = [FirstString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 SecondString = [SecondString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 ThirdString = [ThirdString stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 FirstString = [FirstString substringWithRange:NSMakeRange(31, [FirstString length]-31)];
                  SecondString = [SecondString substringWithRange:NSMakeRange(25, [SecondString length]-25)];
                  ThirdString = [ThirdString substringWithRange:NSMakeRange(25, [ThirdString length]-25)];
                 NSArray* FirstArray = [FirstString componentsSeparatedByString:@"\\"];
                  NSArray* secondArray = [SecondString componentsSeparatedByString:@"\\"];
                  NSArray* ThirdArray = [ThirdString componentsSeparatedByString:@"\\"];
                 NSLog(@"first thing is:%@",[FirstArray objectAtIndex:0]);
                  NSLog(@"second thing is:%@",[secondArray objectAtIndex:0]);
                  NSLog(@"third thing is:%@",[ThirdArray objectAtIndex:0]);
                 [finalArray addObject:[FirstArray objectAtIndex:0]];
                  [finalArray addObject:[secondArray objectAtIndex:0]];
                  [finalArray addObject:[ThirdArray objectAtIndex:0]];
                 NSLog(@"third thing is:%@",finalArray);
             }
             if([foo count]==2){
                 NSString *FirstString = [NSString stringWithFormat:@"%@",[foo objectAtIndex:0]];
                 NSString *SecondString = [NSString stringWithFormat:@"%@",[foo objectAtIndex:1]];
                 FirstString = [FirstString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 SecondString= [SecondString stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 FirstString =[FirstString substringWithRange:NSMakeRange(31, [FirstString length]-31)];
                 SecondString =[SecondString substringWithRange:NSMakeRange(25, [SecondString length]-25)];
        
                 NSArray* FirstArray = [FirstString componentsSeparatedByString:@"\\"];
                 NSArray* secondArray = [SecondString componentsSeparatedByString:@"\\"];
       
                 [finalArray addObject:[FirstArray objectAtIndex:0]];
                 [finalArray addObject:[secondArray objectAtIndex:0]];
             }
             if([foo count]==1){
                 if([[foo objectAtIndex:0]  isEqual:@"(null)"]){
                     [finalArray addObject:[NSString stringWithFormat:@"null"]];
                 }else{
                     NSString *FirstString=[NSString stringWithFormat:@"%@",[foo objectAtIndex:0]];
                     FirstString = [FirstString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                     FirstString = [FirstString substringWithRange:NSMakeRange(31, [FirstString length]-31)];
                    //NSLog(@"first thing is:%@",FirstString);
                     NSArray* FirstArray = [FirstString componentsSeparatedByString:@"\\"];
                     //  NSLog(@"first thing is:%@",[FirstArray objectAtIndex:0]);
                     [finalArray addObject:[FirstArray objectAtIndex:0]];
                 }
             }
             double steps = [quantity doubleValueForUnit:[HKUnit countUnit]];
             NSDictionary *dict = @{@"steps" : @(steps),
                                    @"Start date": dateString,
                                    @"End date": endDateString,
                                    @"QuantityType": quantityString,
                                    @"deviceType":[NSString stringWithFormat:@"%@",finalArray]
                                    };
             //HKQuantitySample *sample;
            // NSLog(@"sources data are:%@",dict);
             [mutArray addObject:dict];
         }];
//        NSInteger step = 0;
//        for (int i = 0;i<mutArray.count;i++) {
//            NSString *str =  [NSString stringWithFormat:@"%@",[[mutArray valueForKey:@"steps"]objectAtIndex:i]];
//            step = [str integerValue];
//            if (step == 0) {
//            }
//            else{
//                break;
//            }
//        }
//        if (step != 0) {
//        }
//        else{
//            self->mutArray = [NSMutableArray new];
//            [self showAcessPopup];
//        }
       // array = [mutArray mutableCopy];
     /*
        NSMutableArray *array1 = [NSMutableArray new];
        NSMutableArray *array2 = [NSMutableArray new];
        NSMutableArray *array3 = [NSMutableArray new];
        NSMutableArray *array4 = [NSMutableArray new];
        NSMutableArray *array5 = [NSMutableArray new];
        NSMutableArray *array6 = [NSMutableArray new];
        NSMutableArray *array7 = [NSMutableArray new];
        for (int i = 0;i<mutArray.count;i++) {
            NSString *str =  [NSString stringWithFormat:@"%@",[[mutArray valueForKey:@"Start date"]objectAtIndex:i]];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [format dateFromString:str];
            [format setDateFormat:@"MM-dd-yyyy"];
            NSString* finalDateString = [format stringFromDate:date];
            NSMutableArray *array = [NSMutableArray new];
           for(int j = 0;j<mutArray.count;j++) {
               NSString *str =  [NSString stringWithFormat:@"%@",[[mutArray valueForKey:@"Start date"]objectAtIndex:j]];
               NSDateFormatter *format = [[NSDateFormatter alloc] init];
               [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               NSDate *date = [format dateFromString:str];
               [format setDateFormat:@"MM-dd-yyyy"];
               NSString* finalDateString1 = [format stringFromDate:date];
               if ([finalDateString isEqualToString:finalDateString1]) {
                   [array addObject:[mutArray objectAtIndex:j]];
               }
           }
            if (i == 0) {
                [array1 addObject:array];
            }
            else if(i == 1){
                [array2 addObject:array];
            }
        }
        */
        NSError* error1 = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutArray options:NSJSONWritingPrettyPrinted error:&error1];
        self.StepCountStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"hello is:%@",mutArray);
         // [self posting];
        if (completionHandler) {
            completionHandler(mutArray, error);
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self->spinner stopAnimating];
        }) ;
    };
    [self.healthStore executeQuery:query];
    //[self retrieveWorkouts1];
}
-(void)showAcessPopup{
    NSString *str = @"Please enble permissions,tap Health,tap on our app and turn AllCategories On";
    UIAlertController *alertCntroller = [UIAlertController alertControllerWithTitle:@"Health" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel  = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *health  = [UIAlertAction actionWithTitle:@"Health" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"x-apple-health://"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    [alertCntroller addAction:Cancel];
    [alertCntroller addAction:health];
    [self presentViewController:alertCntroller animated:YES completion:nil];
}
-(void)postWorkoutData{
    NSMutableArray *array2 = [NSMutableArray new];
    for (int i=0; i<mutArray.count; i++) {
        if (array2.count==0) {
            [array2 addObject:[mutArray objectAtIndex:i]];
        }
        else if ([[array2 valueForKey:@"start_date" ] containsObject:[[mutArray objectAtIndex:i] valueForKey:@"start_date"]])
        {
            [array2 removeObject:[mutArray objectAtIndex:i]];
        }
        else
        {
            [array2 addObject:[mutArray objectAtIndex:i]];
        }
    }
    NSLog(@"count :%lu",array2.count);
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array2 options:NSJSONWritingPrettyPrinted error:&error];
    self.workOutStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",self.workOutStr);
    
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:[self.datePicker date]];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:@"389", @"user",
                             dateString,@"belong_to",self.workOutStr,@"data",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    //    NSString *urlString = [NSString stringWithFormat:@"http://192.168.10.137:8000/apple/users/datasteps"];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://app.jvbwellness.com/apple/users/dataactivities"]];
    [postRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:postData];
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"response is:%@",resSrt);
    */
    
}
-(void)postStepData{
    NSError *error;
    NSDate * dateOut_ = nil;
      NSString *newPINString = [self getRandomPINString:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate:[self.datePicker date]];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys:@"389",@"user",dateString,@"belong_to",self.StepCountStr,@"data",newPINString,@"summary_id",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    //    NSString *urlString = [NSString stringWithFormat:@"http://192.168.10.137:8000/apple/users/datasteps"];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://app.jvbwellness.com/apple/users/datasteps"]];
    [postRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // Designate the request a POST request and specify its body data
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:postData];
    NSError *err;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&err];
    NSString *resSrt = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"response is:%@",resSrt);
}
-(void)retrieveWorkouts1{
    mutArray = [NSMutableArray new];
    /*
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.endDateWorkout = [self.datePicker date];
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components2 = [[NSDateComponents alloc] init];
        components2.day = -1;
        self.endDateWorkout = [calendar1 dateByAddingComponents:components2 toDate:_endDateWorkout options:0];
        NSLog(@"enddate workouts are:%@",self.endDateWorkout);
    }) ;
    NSDateComponents *components = [[NSCalendar currentCalendar]components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
        fromDate:[NSDate date]];
    NSDate *TodayDate = [[NSCalendar currentCalendar]dateFromComponents:components];
    NSDateComponents *components1 = [[NSCalendar currentCalendar]components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.endDateWorkout];
    NSDate *PickerDate = [[NSCalendar currentCalendar]
    dateFromComponents:components1];
    NSComparisonResult result = [TodayDate compare:PickerDate];
    //    if([startDate isEqualToDate:[NSDate date]])
    //    {
    switch (result){
        case NSOrderedAscending:{
                NSLog(@"%@ is in future from %@", self.endDateWorkout, [NSDate date]);
            }
        break;
        case NSOrderedDescending:{
                NSLog(@"%@ is in past from %@", self.endDateWorkout, [NSDate date]);
            }
        break;
        case NSOrderedSame:{
                // NSLog(@"%@ is the same as %@", otherDate, currentDate);
                NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                [cal setTimeZone:[NSTimeZone systemTimeZone]];
                NSDateComponents * comp = [cal components:( NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
                [comp setMinute:0];
                [comp setHour:0];
                [comp setSecond:0];
                NSLog(@"start date is%@",self.endDateWorkout);
                self.endDateWorkout = [cal dateFromComponents:comp];
            }
        break;
        default:{
                NSLog(@"erorr dates %@, %@", self.endDateWorkout, [NSDate date]);
            }
        break;
    }
     */
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:self.endDateWorkout options:0];
//    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
//    [dateFormat1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
//    static NSString *strToday = @"";
//    dispatch_async(dispatch_get_main_queue(), ^(void) {
//     strToday = [dateFormat1  stringFromDate:[self->_datePicker date]];
//    });
      NSDate *newDate = [NSDate new];
      NSDate *EDate = self.datePicker.date;
      NSDate *EDate1 = self.datePicker.date;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
   NSString *edate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    
    self.endDateWorkout = self.datePicker.date;
    NSPredicate *timeInterval;
    if ([daysString isEqualToString:@"oneday"])
    {
        newDate = [self.endDateWorkout dateByAddingTimeInterval:1.0 * 60.0 * 60.0 * 24.0];
        timeInterval =[HKQuery predicateForSamplesWithStartDate:self.endDateWorkout endDate:newDate options:HKQueryOptionNone];
    }
    else{
        newDate = [self.endDateWorkout dateByAddingTimeInterval:-7.0 * 60.0 * 60.0 * 24.0];
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:self.endDateWorkout options:0];
        NSLog(@"nextDate: %@ ...", nextDate);
        timeInterval =[HKQuery predicateForSamplesWithStartDate:newDate endDate:nextDate options:HKQueryOptionStrictEndDate];
    }
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSString *formatStr = [formatter stringFromDate:EDate1];
//    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
//    if ([formatStr isEqualToString:dateStr]) {
//        self.endDateWorkout = [NSDate date];
//    }
//    else{
//        self.endDateWorkout = [newDate dateByAddingTimeInterval:-1.0];
//    }
//    strdate  = [strdate a]
//    NSDate *todaydate = [dateFormat1 dateFromString:strToday];
//    NSString *strlastDay = [dateFormat1  stringFromDate:startDate];
//    NSDate *lastDate = [dateFormat1 dateFromString:strlastDay];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:HKSampleSortIdentifierStartDate ascending:false];
    HKWorkoutType *type = [HKWorkoutType workoutType];
    HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:type];
    BOOL isActive;
    switch (status) {
        case HKAuthorizationStatusSharingAuthorized:
            isActive = YES;
            break;
        case HKAuthorizationStatusSharingDenied:
            [self showAcessPopup];
            isActive = NO;
            return;
        case HKAuthorizationStatusNotDetermined:
            isActive = NO;
            break;
        default:
            break;
    }
    NSLog(@"STATUS-------%@", isActive ? @"yes" : @"no");
    // 3. Create the query
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:type
        predicate:timeInterval limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error){
         if(!error && results){
            NSLog(@"Retrieved the following workouts");
            for(HKQuantitySample *samples in results)
            {
                //your code here
                HKWorkout *workout = (HKWorkout *)samples;
                NSDate *startDate = workout.startDate;
                NSString *humidityString;
                self->_timeZone=[[NSString alloc]init];
                NSString *weatherString;
                for (HKSample *samples1 in results) {
                //NSString *mohan=samples1.metadata;
                    NSLog(@"metadata is :%@",samples.metadata);
                    humidityString=[NSString stringWithFormat:@"%@",[samples.metadata valueForKey:@"HKWeatherHumidity"]];
                    self->_timeZone=[NSString stringWithFormat:@"%@",[samples.metadata valueForKey:@"HKTimeZone"]];
                    self.timeZone = [self.timeZone stringByReplacingOccurrencesOfString:@"/"  withString:@"-"];
                    weatherString=[NSString stringWithFormat:@"%@",[samples.metadata valueForKey:@"HKWeatherTemperature"]];
                    NSLog(@"metadata is 123:%@",weatherString);
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *dateString = [formatter stringFromDate:startDate];
                NSString *endDateString=[formatter stringFromDate:workout.endDate];
                NSString *quantityString = [NSString stringWithFormat:@"%lu",(unsigned long)workout.workoutActivityType];
                NSString *quantityString1 = [NSString stringWithFormat:@"%@",workout.sourceRevision];
                NSArray *items = [quantityString1 componentsSeparatedByString:@","];
                NSString *Device=[items objectAtIndex:1];
                Device =[Device substringWithRange:NSMakeRange(6, [Device length]-6)];
                NSLog(@"%@",workout.startDate);
                NSString *workoutActivity = [WorkoutActivityConversion convertHKWorkoutActivityTypeToString:workout.workoutActivityType];
                if(![workoutActivity isEqual:@"unknown"]){
                    workoutActivity =[workoutActivity substringWithRange:NSMakeRange(21, [workoutActivity length]-21)];
                    NSLog(@"workout type %@",workoutActivity);
                }
                NSString *durationString = [NSString stringWithFormat:@"%f Sec",workout.duration];
                int time=workout.duration;
               
                double distance = [[workout totalDistance] doubleValueForUnit:[HKUnit meterUnit]];
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"0.##"];
                NSString *distanceString =[NSString stringWithFormat:@"%@", [fmt stringFromNumber:[NSNumber numberWithFloat:distance]]];
                NSLog(@"workout device:%@",workout.device);
                NSLog(@"workout duration:%f",workout.duration);
                NSLog(@"workout endDate:%@",workout.endDate);
                NSLog(@"workout metadata:%@",workout.metadata);
                NSLog(@"workout sampleType:%@",workout.sampleType);
                NSLog(@"workout sourceRevision:%@",workout.sourceRevision);
                NSLog(@"workout startDate:%@",workout.startDate);
                NSLog(@"workout totalDistance:%@",workout.totalDistance);
                NSLog(@"workout totalEnergyBurned:%@",workout.totalEnergyBurned);
                NSLog(@"workout totalFlightsClimbed:%@",workout.totalFlightsClimbed);
                NSLog(@"workout totalSwimmingStrokeCount:%@",workout.totalSwimmingStrokeCount);
                NSLog(@"workout UUID:%@",workout.UUID);
                NSLog(@"workout workoutActivityType:%lu",(unsigned long)workout.workoutActivityType);
                NSLog(@"workout workoutEvents:%@",workout.workoutEvents);
                NSLog(@"workout workoutActivityType:%@",workout.sampleType);
                NSDate *dateStart = workout.startDate;
                NSDate *dateEnd = workout.endDate;
                NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
                [UserDefaults setObject:workout.startDate forKey:@"StartDate"];
                [UserDefaults setObject:workout.endDate forKey:@"EndDate"];

                double SwimmingStrokeCount =  [[workout totalSwimmingStrokeCount] doubleValueForUnit:[HKUnit kilocalorieUnit]];
                NSString *SwimmingStrokeCountString = [NSString stringWithFormat:@"%@", [fmt stringFromNumber:[NSNumber numberWithFloat:SwimmingStrokeCount]]];
                double totalFlightsClimbed =  [[workout totalFlightsClimbed] doubleValueForUnit:[HKUnit footUnit]];
                NSString *totalFlightsClimbedString = [NSString stringWithFormat:@"%@", [fmt stringFromNumber:[NSNumber numberWithFloat:totalFlightsClimbed]]];
                double totalEnergyBurned =  [[workout totalSwimmingStrokeCount] doubleValueForUnit:[HKUnit kilocalorieUnit]];
                NSString *totalEnergyBurnedString = [NSString stringWithFormat:@"%@", [fmt stringFromNumber:[NSNumber numberWithFloat:totalEnergyBurned]]];
                HKQuantityType *type1 = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
                // Your interval: sum by hour
                NSDateComponents *intervalComponents1 = [[NSDateComponents alloc] init];
                intervalComponents1.hour = 1;
                // Example predicate
                NSPredicate *predicate1 = [HKQuery predicateForSamplesWithStartDate:dateStart endDate:dateEnd options:HKQueryOptionStrictStartDate];
                HKStatisticsCollectionQuery *query1 = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:type1 quantitySamplePredicate:predicate1 options:HKStatisticsOptionSeparateBySource anchorDate:dateStart intervalComponents:intervalComponents1];
                query1.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results1, NSError *error)
                {
                    [results1 enumerateStatisticsFromDate:dateStart toDate:dateEnd withBlock:^(HKStatistics *result1, BOOL *stop)
                    {
                        HKQuantity *quantity1 = result1.sumQuantity;
                        double steps = [quantity1 doubleValueForUnit:[HKUnit countUnit]];
                        NSString *stepsString =[NSString stringWithFormat:@"%@", [fmt stringFromNumber:[NSNumber numberWithFloat:steps]]];
                        NSLog(@"steps are%@",result1.sumQuantity);
                       // [self updateHeartbeat:dateStart endDate:dateEnd];
                        HKQuantityType *typeHeart =[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
                        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:dateStart endDate:dateEnd options:HKQueryOptionStrictStartDate];
                        HKStatisticsQuery *squery = [[HKStatisticsQuery alloc] initWithQuantityType:typeHeart quantitySamplePredicate:predicate options:HKStatisticsOptionDiscreteAverage completionHandler:^(HKStatisticsQuery *query, HKStatistics *result2, NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                HKQuantity *quantity2 = result2.averageQuantity;
                                double beats = [quantity2 doubleValueForUnit:[[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]]];
                                NSString *averageHearthRateString = [NSString stringWithFormat:@"%@", [fmt stringFromNumber:[NSNumber numberWithFloat:beats]]];
                                HKQuantity *quantity3 =  result2.maximumQuantity;
                                NSLog(@"got123456: %@", [NSString stringWithFormat:@"%@",quantity3]) ;
                                [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"Date"];
                                NSString *duration = [NSString stringWithFormat:@"%d",time];
                                NSTimeZone *localTimeZone = [NSTimeZone timeZoneWithAbbreviation:self.timeZone];
                                NSLog(@"timezone is :%@",localTimeZone);
                                if([self.timeZone isEqualToString:@""]){
                                    // definitely empty!
                                    NSTimeZone *tz = NSTimeZone.systemTimeZone;
                                    self.timeZone=[NSString stringWithFormat:@"nil"];
                                }
                                NSString *newPINString = [self getRandomPINString:10];
                                NSDictionary *dict = @{@"WorkoutType"        :workoutActivity,
                                @"start_date"         :dateString,
                                @"End date"           :endDateString,
                                @"deviceType"         :Device,
                                @"Duration"           :duration,
                                @"Distance"           :distanceString
                               ,@"steps"              :stepsString,
                                @"AverageHearthRate"  :averageHearthRateString,
                                @"ActivityID"         :newPINString,
                            @"SwimmingStrokeCount":SwimmingStrokeCountString,
                             @"totalFlightsClimbed":totalFlightsClimbedString,
                                @"totalEnergyBurned"  :totalEnergyBurnedString,
                                @"TimeZone"           :self.timeZone,
                                @"WeatherHumidity"    :humidityString,
                                @"WeatherTemperature" :weatherString
                               // @"MaximumHearthRate":@(max)
                                };
                                [self->mutArray addObject:dict];
                //            }];
        //                };
                            });
                        }];
                        [self.healthStore executeQuery:squery];
                    }];
                };
                [self.healthStore executeQuery:query1];
            }
         }else{
            NSLog(@"Error retrieving workouts %@",error);
        }
    }];
    [self->_healthStore executeQuery:sampleQuery];
}
-(void)GetStepsDuringWorkout:(NSDate *)StartDateForSteps endDate:(NSDate *)endDateForSteps
{
    HKQuantityType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    // Your interval: sum by hour
    NSDateComponents *intervalComponents = [[NSDateComponents alloc] init];
    intervalComponents.hour = 1;
    // Example predicate
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:StartDateForSteps endDate:endDateForSteps options:HKQueryOptionStrictStartDate];
    HKStatisticsCollectionQuery *query1 = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:type quantitySamplePredicate:predicate options:HKStatisticsOptionSeparateBySource anchorDate:StartDateForSteps intervalComponents:intervalComponents];
    query1.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *results, NSError *error) {
        [results
         enumerateStatisticsFromDate:StartDateForSteps
         toDate:endDateForSteps
         withBlock:^(HKStatistics *result, BOOL *stop) {
              HKQuantity *quantity = result.sumQuantity;
               double steps = [quantity doubleValueForUnit:[HKUnit countUnit]];
             NSLog(@"steps are%f",steps);
         }];
    };
    [self.healthStore executeQuery:query1];
}
-(NSString *)getRandomPINString:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    NSString *numbers = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    for (int i = 1; i < length; i++)
    {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    return returnString;
}
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSHTTPURLResponse *)response {
    if (response != nil) {
        NSArray* authToken = [NSHTTPCookie
                              cookiesWithResponseHeaderFields:[response allHeaderFields]
                              forURL:[NSURL URLWithString:@""]];
        
        if ([authToken count] > 0) {
            NSLog(@"cookies from the http POST %@", authToken);
        }
    }
    return request;
}


/**
 This method executes the timer for calling the method.
 */
- (void) startRNBackgroundTask
{
    NSLog(@" Executing-> Background state Task method. ");
    //create new uiBackgroundTask
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //run function after every 900 seconds OR 15 mins
        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:900  target:self selector:@selector(performBackgroundtask:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
}

/**
 This method will be called after every 15 minutes.
 */
- (void) performBackgroundtask: (NSTimer *)timer {
    NSLog(@" Executing task in every 15 minutes in Background state. ");
}

/**
 This method is for checking the functionality in killed state.
 */
- (void)runTaskInKilledState {
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
//        // do something
//        NSLog(@" #---> application was not active  ");
//    } else {
//        NSLog(@" #---> app is active or in background");
//    }
    UIApplication *app = [UIApplication sharedApplication];		
    __block UIBackgroundTaskIdentifier bgTask  = UIBackgroundTaskInvalid;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    /**
     Need to check the functionality as iOS restricts the task when the app is terminated,
     so the timer block is commented.
     */
    //and create new timer with async call:
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        //run function after every 900 seconds OR 15 mins
    //        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:20  target:self selector:@selector(performTaskInKilledState:) userInfo:nil repeats:YES];
    //        [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
    //        [[NSRunLoop currentRunLoop] run];
    //    });
    NSLog(@" Killed state method is called");
    [app endBackgroundTask:bgTask];
    
}

//- (void) performTaskInKilledState: (NSTimer *)timer {
//    NSLog(@" Killed state - Executing task in every 15 minutes in Background state. ");
//}

@end
