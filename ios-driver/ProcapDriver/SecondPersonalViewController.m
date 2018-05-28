//
//  SecondPersonalViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/26/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "SecondPersonalViewController.h"

@interface SecondPersonalViewController ()

@end

@implementation SecondPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    datePicketViewShown = tableContainerShown = NO;
    
    selectedDistrictCode = selectedNationalityCode = selectedDrivingLicenseExpiryDate = @"";
    
    if([[HelperClass getDeviceLanguage] isEqualToString:@"ar"]){
        self.nationalityLabel.textAlignment = NSTextAlignmentRight;
        self.districtLabel.textAlignment = NSTextAlignmentRight;
        self.drivingLicenseExpiryLabel.textAlignment = NSTextAlignmentRight;
    }
    
    [self drawSelectionsView];
    
    //Search Array
    currentSearchingArray = [[NSMutableArray alloc] init];
    
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 595);
    
    [_streetTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_referralCodeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    streetConst = _streetTop.constant;
    districtConst = _districtTop.constant;
    nationalityConst = _nationalityTop.constant;
    referralCodeConst = _referralTop.constant;
    drivingLicExpiryConst = _drivingLicenseTop.constant;
    
    _drivingLicImageContainerView.layer.borderWidth = 1.0f;
    _drivingLicImageContainerView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.25f].CGColor;
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_drivingLicImageContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _drivingLicImageContainerView.layer.shadowPath = shadowPath.CGPath;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_mainScrollView addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

-(void)drawSelectionsView{
    /*Date Picker Work*/
    //Container View
    datePickerContainerView = [[UIView alloc] init];
    datePickerContainerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    datePickerContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datePickerContainerView];
    //Done Button
    pickersDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickersDoneButton addTarget:self action:@selector(DonePickerAction:) forControlEvents:UIControlEventTouchUpInside];
    [pickersDoneButton setTitle:@"Show View" forState:UIControlStateNormal];
    pickersDoneButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 40.0);
    pickersDoneButton.backgroundColor = [UIColor colorWithRed:35.0/255.0f green:46.0/255.0f blue:66.0/255.0f alpha:0.5f];
    [pickersDoneButton setTitle:NSLocalizedString(@"any_done", @"") forState:UIControlStateNormal];
    [datePickerContainerView addSubview:pickersDoneButton];
    //Picker
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickersDoneButton.frame.size.height, self.view.frame.size.width, 220)];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePickerContainerView addSubview:datePicker];
    
    /*Selection Table Work*/
    //Container View
    tableContainerView = [[UIView alloc] init];
    tableContainerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    tableContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableContainerView];
    //Done Button
    tableDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableDoneButton addTarget:self action:@selector(doneTableAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableDoneButton setTitle:@"Show View" forState:UIControlStateNormal];
    tableDoneButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 40.0);
    tableDoneButton.backgroundColor = [UIColor colorWithRed:35.0/255.0f green:46.0/255.0f blue:66.0/255.0f alpha:0.5f];
    [tableDoneButton setTitle:NSLocalizedString(@"any_done", @"") forState:UIControlStateNormal];
    [tableContainerView addSubview:tableDoneButton];
    //SearchBar
    _tablesSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, tableDoneButton.frame.size.height, self.view.frame.size.width, 40)];
    _tablesSearchBar.delegate = self;
    _tablesSearchBar.showsCancelButton = YES;
    _tablesSearchBar.returnKeyType = UIReturnKeyDone;
    _tablesSearchBar.placeholder = NSLocalizedString(@"personal_search_placeholder", @"");
    [tableContainerView addSubview:_tablesSearchBar];
    //table
    dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableDoneButton.frame.size.height + _tablesSearchBar.frame.size.height, self.view.frame.size.width, 180)];
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    [tableContainerView addSubview:dataTableView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    districtsArray = [self.applicationDelegate.appRules objectForKey:@"districts"];
    nationalitiesArray = [self.applicationDelegate.appRules objectForKey:@"nationalities"];
    
    
    maxDLExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"maxExpiry"] fromFormat:@"YYYY/MM/dd"];
    minDLExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"minExpiry"] fromFormat:@"YYYY/MM/dd"];
    
    self.firstPersonalInfo = [ServiceManager getTempPersonalInfo];
    NSLog(@"personal info : %@", self.firstPersonalInfo);
    if(!self.firstPersonalInfo){
        NSLog(@"self.firstPersonalInfo is null");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self showHidePickerView:NO];
    [self showTableContainer:0 andShow:NO];
    
    [self deregisterForKeyboardNotifications];
}
- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - Personal Info Registration Request

-(void)processCompletePersonalInfoRequest
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTokenString"];
    NSLog(@"device token : %@", deviceToken);
  NSDictionary *parameters =
    @{
      @"otp" : (self.otpCode.length > 0) ? self.otpCode : @"",
      @"device" : @"ios",
      @"deviceId" : (deviceToken.length > 0) ? deviceToken : @"",
      @"driver": @{
              @"birthdate": self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERTDATA_API_BIRTHDATE] : @"",
              @"city" : @"riyadh",
              @"country" : @"sa",
              @"dialCode" : @"966",
              @"district" : ((selectedDistrictCode.length > 0) && selectedDistrictCode) ? selectedDistrictCode : @"",
              @"licenseExpiry" : (drivingLicenseExpiryDate && drivingLicenseExpiryDate && ![drivingLicenseExpiryDate isEqual:[NSNull null]]) ? [NSString stringWithFormat:@"%f", selectedDrivingLicenseExpiryInMiliseconds] : @"",
              @"language" : @"ar",
              @"email": self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERDATA_API_EMAIL] : @"",
              @"firstName": self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERDATA_API_FNAME] : @"",
              @"lastName" : self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERDATA_API_LNAME] : @"",
              @"nationality" : ((selectedNationalityCode.length > 0) && selectedNationalityCode) ? selectedNationalityCode : @"",
              @"password" : self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERDATA_API_PASSWORD] : @"",
              @"passwordConfirmation" : self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERDATA_API_PASSWORD] : @"",
              @"phone" : (self.phoneNumber.length > 0) ? self.phoneNumber : @"",
              @"ssn": self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERTDATA_API_SSN] : @"",
              @"ssnExpiry": self.firstPersonalInfo ? [self.firstPersonalInfo objectForKey:DRIVERTDATA_API_SSN_EXPIRY] : @"",
              @"street" : (self.streetTF.text.length > 0) ? self.streetTF.text : @"",
              @"hearingImpaired" : hearingImpaired ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0],
              @"mobilityImpaired" : mobilityImpaired ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0]
              }
      };
    NSLog(@"ClientSide Validation full driver info : %@", parameters);
    NSDictionary *validation = [ClientSideValidation validateGeneralInfoData:[parameters objectForKey:@"driver"]];
    
    if([[validation objectForKey:@"isAllValid"] isEqualToString:@"1"]){
        if(self.applicationDelegate.drivingLicenseImage){
            NSLog(@"client side validation passed with response : %@", validation);
            /* Passed Client-Side validations */
            /* Show loading View */
            [self.delegate showRootLoadingView];
            [self.view endEditing:YES];
            NSLog(@"will add full driver info data %@", parameters);
            [self performSelectorInBackground:@selector(fullPersonalInfoRequest:) withObject:parameters];
        }else{
            self.drivingLicenseLabel.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
            [HelperClass showAlert:NSLocalizedString(@"general_license_image_missing_title", @"") andMessage:NSLocalizedString(@"general_license_image_missing_message", @"")];
        }
    }else{
        NSLog(@"client side validation NOT passed with response : %@", validation);
        [self shakeMissingFields:validation];
    }
}

-(void)fullPersonalInfoRequest:(NSDictionary *)requestParameters
{
    @autoreleasepool {
        BOOL registered = [ServiceManager personalInfoRegister:requestParameters :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishCompletePersonalInfoRequest:) withObject:response waitUntilDone:NO];
        }];
        if(!registered)
            [self performSelectorOnMainThread:@selector(finishCompletePersonalInfoRequest:) withObject:nil waitUntilDone:NO];
    }
}

-(void)finishCompletePersonalInfoRequest:(NSDictionary *)driverData{
    [self.delegate hideRootLoadingView];
    NSLog(@"done complete personal info request %@", driverData);
    if(driverData && [driverData objectForKey:@"data"]){
        NSLog(@"full driver info validation successful with data %@ and go to second screen", [driverData objectForKey:@"data"]);
        if([ServiceManager saveLoggedInDriverData:[driverData objectForKey:@"data"] andAccessToken:[[driverData objectForKey:@"session"] objectForKey:@"accessToken"]]){
            
            //If driver saved to device,
            //Delete Phone Session
            [ServiceManager deletePhoneSessionFromKeychain];
            NSLog(@"check phone session deleted : %@", [ServiceManager getPhoneSession]);
            //Move to vehicle registeration screen
            [ServiceManager saveCurrentRegisterationStep:@"vehicle"];
            [self moveToVehicleScreen];
        }else{
            [HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")];
        }
    }else{
        /* Failed */
        NSLog(@"PersonalInfoRequest failed with data  :%@", [driverData objectForKey:@"code"]);
        [self serverSideValidation:driverData];
    }
}

-(void)moveToVehicleScreen{
    [self.delegate goToVehicleRegisteration];
}

- (IBAction)addDrivingLicenseImageAction:(UIButton *)sender {
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:NSLocalizedString(@"Chose_camera_source_title", @"") message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camBtn = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Chose_camera_source_first_option", @"")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self showImageController:0];
                             }];
    UIAlertAction *libraryBtn = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Chose_camera_source_second_option", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self showImageController:1];
                                     
                                 }];
    UIAlertAction *cancelBtn = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Chose_camera_source_cancel", @"")
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction:camBtn];
    [alert addAction:libraryBtn];
    [alert addAction:cancelBtn];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)showImageController:(int)sourceType{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    switch (sourceType) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            break;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)chooseDrivingLicenseExpiryDate:(UIButton *)sender {
    NSLog(@"should show picker ID Expiry");
    datePicker.maximumDate = maxDLExpiry;
    datePicker.minimumDate = minDLExpiry;
    
    datePicketViewShown = NO;
    [self showHidePickerView:YES];
}

-(void) showHidePickerView:(BOOL)show{
    if(tableContainerShown)
        [self showTableContainer:0 andShow:NO];
    [self.view endEditing:YES];
    datePicketViewShown = show;
    [self.delegate addSubView:datePickerContainerView andShow:show andMoveFooter:NO];
}



- (IBAction)chooseDistrictAction:(UIButton *)sender {
    currentChoosingTable = 2;
    [dataTableView reloadData];
    [self showTableContainer:2 andShow:YES];
}

- (void)showTableContainer:(int)tableToShow andShow:(BOOL)show {
    
    [self.view endEditing:YES];
    [dataTableView reloadData];
    if(datePicketViewShown)
        [self showHidePickerView:NO];
    tableContainerShown = show;
    [self.delegate addSubView:tableContainerView andShow:show andMoveFooter:!(currentChoosingTable == 2)];
    
}

- (IBAction)chooseNationalityAction:(UIButton *)sender {
    currentChoosingTable = 3;
    [dataTableView reloadData];
    [self showTableContainer:3 andShow:YES];
    
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    
    selectedDrivingLicenseExpiryDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
    drivingLicenseExpiryDate = sender.date;
    [_drivingLicExpiryBtn setTitle:selectedDrivingLicenseExpiryDate forState:UIControlStateNormal];
    
    selectedDrivingLicenseExpiryInMiliseconds = [sender.date timeIntervalSince1970]*1000;
    
    _drivingLicenseTop.constant = drivingLicExpiryConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _drivingLicenseExpiryLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
    
    [_drivingLicExpirySubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_drivingLicExpiryBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
}

- (IBAction)DonePickerAction:(UIButton *)sender {
    [self showHidePickerView:NO];
}

- (IBAction)doneTableAction:(UIButton *)sender {
    [self showTableContainer:0 andShow:NO];
    [_tablesSearchBar endEditing:YES];
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    if(datePicketViewShown){
        [self showHidePickerView:NO];
    }
    if(tableContainerShown){
        [self showTableContainer:0 andShow:NO];
        if(viewSearching)
            [_tablesSearchBar endEditing:YES];
    }
}

#pragma mark - Textfields delegate
#pragma mark - UITextFieldDelegate
-(void)textFieldDidChange :(UITextField *)textField{
    UILabel *currentLabel;
    NSLayoutConstraint *constraint;
    if(textField == _streetTF){
        constraint = _streetTop;
        constraint.constant = streetConst - 30;
        currentLabel = _streetLabel;
    }else if (textField == _referralCodeTF){
        constraint = _referralTop;
        constraint.constant = referralCodeConst - 30;
        currentLabel = _referralCodeLabel;
    }
    
    if(textField.text.length > 0){
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.view layoutIfNeeded];
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                         }  completion:^(BOOL finished){}];
    }else{
        constraint.constant = constraint.constant + 30;
        [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.view layoutIfNeeded];
                             currentLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:16];
                         }  completion:^(BOOL finished){}];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.rightViewMode = UITextFieldViewModeNever;
    if(datePicketViewShown)
        [self showHidePickerView:NO];
    if(tableContainerShown)
        [self showTableContainer:0 andShow:NO];
    
    if(textField == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    
    if(textField == _streetTF)
        [_streetSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.streetTF){
        if (textField.text.length > 59 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}
    }
    if(textField == self.referralCodeTF){
        if (textField.text.length > 5 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}
    }
    
    return YES;
}

#pragma mark - Keyboard
#pragma mark - Keyboard Show/Hide Methods
/* Keyboard will show (a textfield became active) */
- (void)keyboardWillShow:(NSNotification*)notification {
    if((self.referralCodeTF.editing)){
        [self.delegate moveViewForTextFields:130 andShow:YES];
    }else if(viewSearching){
        NSDictionary *info = [notification userInfo];
        /* Get keyboard size */
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [self.delegate moveViewForSearch:kbSize.height andShow:YES];
    }
}

/* Keyboard will hide (active textfield became inactive) */
- (void)keyboardWillHide:(NSNotification*)notification {
    [self.delegate moveViewForTextFields:0 andShow:NO];
    [self.delegate moveViewForSearch:0 andShow:YES];
}
#pragma mark - SearchBar delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText isEqualToString:@""]){
        searching = NO;
        [dataTableView reloadData];
    }else{
        NSLog(@"searching and text : %@", searchText);
        searching = YES;
        [currentSearchingArray removeAllObjects];
        NSArray *currentArray = [[NSArray alloc] init];
        switch (currentChoosingTable) {
            case 2:
                currentArray = districtsArray;
                break;
            case 3:
                currentArray = nationalitiesArray;
                break;
                
            default:
                break;
        }
        for (NSMutableDictionary *temp in currentArray)
        {
            NSRange titleResultsRange = [[temp objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]  rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0){
                [currentSearchingArray addObject:temp];
            }
        }
        NSLog(@"temp array %@", currentSearchingArray);
        [dataTableView reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [self.delegate moveViewForSearch:260 andShow:YES];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    viewSearching = YES;
    return YES;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.delegate moveViewForSearch:0 andShow:NO];
    searching = NO;
    viewSearching = NO;
    [dataTableView reloadData];
    [currentSearchingArray removeAllObjects];
    searchBar.text = @"";
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searching = NO;
    viewSearching = NO;
    [_tablesSearchBar endEditing:YES];
    [dataTableView reloadData];
    [currentSearchingArray removeAllObjects];
    searchBar.text = @"";
}

#pragma mark - Camera Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSData * pngData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    //Check image size limit (5MB)
    if(((float)[pngData length]/1048576) <= 5){
        // get selected image
        UIImage *imageCaptured = info[UIImagePickerControllerEditedImage];
        
        if(imageCaptured){
            self.applicationDelegate.drivingLicenseImage = info[UIImagePickerControllerEditedImage];
            NSLog(@"driving license imaged : %@", _applicationDelegate.drivingLicenseImage);
        }
        //Dismiss camera picker controller
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        // Update ID Image Textfield text
        self.drivingLicenseLabel.textColor = [UIColor whiteColor];
        [self.drivingLicenseCheckmark setImage:[UIImage imageNamed:@"RegWhiteCheckmark"]];
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_image_size_title", @"") andMessage:NSLocalizedString(@"general_image_size_message", @"")] animated:YES completion:nil];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!searching){
        switch (currentChoosingTable) {
            case 2:
                return [districtsArray count];
                break;
            case 3:
                return [nationalitiesArray count];
                break;
                
            default:
                return 1;
                break;
        }
    }else{
        return [currentSearchingArray count];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    switch (currentChoosingTable) {
        case 2:
            selectedDistrictCode = [[!(searching) ? districtsArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:@"code"];

            [_districtBtn setTitle:[[!(searching) ? districtsArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] forState:UIControlStateNormal];
            [self selectDistrict];
            break;
        case 3:
            selectedNationalityCode = [[!(searching) ? nationalitiesArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:@"code"];
            _nationalityLabel.text = [[!(searching) ? nationalitiesArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"];
            [_nationalityBtn setTitle:[[!(searching) ? nationalitiesArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] forState:UIControlStateNormal];
            [self selectNationality];
            break;
            
        default:
            break;
    }
    [self showTableContainer:0 andShow:NO];
    [_tablesSearchBar endEditing:YES];
}

-(void)selectDistrict{
    [_districtSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_districtBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    
    _districtTop.constant = districtConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _districtLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
}
-(void)selectNationality{
    [_nationalitySubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_nationalityBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    
    _nationalityTop.constant = nationalityConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _nationalityLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *cellText = @"";
    switch (currentChoosingTable) {
        case 2:
            cellText = [[!(searching) ? districtsArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"];
            break;
        case 3:
            cellText = [[!(searching) ? nationalitiesArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"];
            break;
            
        default:
            cellText = @"";
            break;
    }
    cell.textLabel.text = cellText;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


-(void)shakeMissingFields:(NSDictionary *)fields{
    if([[fields objectForKey:@"licenseImage"] isEqualToString:@"1"]){
        self.drivingLicenseLabel.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
    }
    if(!(self.applicationDelegate.drivingLicenseImage)){
        self.drivingLicenseLabel.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
    }
    if([[fields objectForKey:@"licenseExpiry"] isEqualToString:@"1"]){
        [self addPopupToField:_drivingLicExpiryBtn andMessage:@"Missing Driving License Expiry" andSubview:_drivingLicExpirySubview];
    }
    if([[fields objectForKey:@"nationality"] isEqualToString:@"1"]){
        [self addPopupToField:_nationalityBtn andMessage:@"Missing Nationality" andSubview:_nationalitySubview];
    }
    if([[fields objectForKey:@"street"] isEqualToString:@"1"]){
        [self addPopupToField:_streetTF andMessage:@"Missing Street" andSubview:_streetSubview];
    }
    if([[fields objectForKey:@"district"] isEqualToString:@"1"]){
        [self addPopupToField:_districtBtn andMessage:@"Missing District" andSubview:_districtSubview];
    }
}

-(void)serverSideValidation:(NSDictionary *)errorData{
    if([[errorData objectForKey:@"code"] intValue] == 400){
        NSString *errorField = [[errorData objectForKey:@"error"] objectForKey:@"field"];
        if([errorField isEqualToString:@"district"]){
            [self addPopupToField:_districtBtn andMessage:@"Missing District" andSubview:_districtSubview];
            
        }else if([errorField isEqualToString:@"licenseExpiry"]){
            [self addPopupToField:_drivingLicExpiryBtn andMessage:@"Missing Driving License Expiry" andSubview:_drivingLicExpirySubview];
            
        }else if([errorField isEqualToString:@"nationality"]){
            [self addPopupToField:_nationalityBtn andMessage:@"Missing Nationality" andSubview:_nationalitySubview];
            
        }else if([errorField isEqualToString:@"street"]){
            [self addPopupToField:_streetTF andMessage:@"Missing Street" andSubview:_streetSubview];
            
        }else if([errorField isEqualToString:@"licenseImage"]){
            self.drivingLicenseLabel.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]] animated:YES completion:nil];
        }else{
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]] animated:YES completion:nil];
        }
    }else if([[errorData objectForKey:@"code"] intValue] == 409){
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"driver_already_exists_title", @"") andMessage:NSLocalizedString(@"driver_already_exists_message", @"")] animated:YES completion:nil];
    }else if([[errorData objectForKey:@"code"] intValue] == 401){
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"not_auth_otp_title", @"") andMessage:NSLocalizedString(@"not_auth_otp_message", @"")] animated:YES completion:nil];
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:NSLocalizedString(@"general_problem_message", @"")] animated:YES completion:nil];
    }
}

-(void)addPopupToField:(UIView *)field andMessage:(NSString *)message andSubview:(UIView *)subview{
    if(popupViewTag && (popupViewTag > 0)){
        UIView *tempView = [self.view viewWithTag:popupViewTag];
        [tempView removeFromSuperview];
        tempView = nil;
    }
    
    subview.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
    
    UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(field.frame.origin.x, field.frame.origin.y + 22, field.frame.size.width, field.frame.size.height)];
    popupView.tag = 131;
    popupView.backgroundColor = [UIColor clearColor];
    popupViewTag = (int)popupView.tag;
    
    UILabel *popupLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, popupView.frame.size.width, popupView.frame.size.height-7)];
    popupLbl.numberOfLines = 2;
    popupLbl.text = message;
    popupLbl.backgroundColor = [UIColor clearColor];
    popupLbl.textAlignment = NSTextAlignmentJustified;
    popupLbl.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:12];
    popupLbl.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
    [popupView addSubview:popupLbl];
    
    [[field superview] addSubview:popupView];
    [self.view bringSubviewToFront:popupView];
    currentFieldPopup = field;
}


- (IBAction)hearImpBtnAction:(UIButton *)sender {
    hearingImpaired = !hearingImpaired;
    if(hearingImpaired)
        [_hearImpBtn setTintColor:[UIColor colorWithRed:246.0/255.0f green:205.0/255.0f blue:171.0/255.0f alpha:1.0f]];
    else
        [_hearImpBtn setTintColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0f]];
}
- (IBAction)impBtnAction:(UIButton *)sender {
    mobilityImpaired = !mobilityImpaired;
    if(mobilityImpaired)
        [_impBtn setTintColor:[UIColor colorWithRed:246.0/255.0f green:205.0/255.0f blue:171.0/255.0f alpha:1.0f]];
    else
        [_impBtn setTintColor:[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1.0f]];
}
@end
