//
//  VehicleRegisterViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "VehicleRegisterViewController.h"

@interface VehicleRegisterViewController ()

@end

@implementation VehicleRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, 532);
    
    isOwner = @"true";
    ownerSelected = YES;
    
    plateLettersText = @"";
    
    inActiveColor = [UIColor colorWithRed:51.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0];
    activeColor = [UIColor whiteColor];
    
    if([[HelperClass getDeviceLanguage] isEqualToString:@"ar"]){
        self.yearLabel.textAlignment = NSTextAlignmentRight;
        self.modelLabel.textAlignment = NSTextAlignmentRight;
        self.manufacturerLabel.textAlignment = NSTextAlignmentRight;
    }
    [self drawSelectionsView];
    //Search Array
    currentSearchingArray = [[NSMutableArray alloc] init];
    
    manConst = _manTop.constant;
    modelConst = _modelTop.constant;
    yearConst = _yearTop.constant;
    plateNumConst = _plateNumbersTop.constant;
    plateLettersConst = _plateLettersTop.constant;
    vehicleRegConst = _vehicleRegTop.constant;
    vehicleExpireConst = _vehicleRegExpireTop.constant;
    
    [_plateNumberTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_plateLettersTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_vehicleRegNumberTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [_mainScrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    _vehicleRegImgContainerView.layer.borderWidth = 1.0f;
    _vehicleRegImgContainerView.layer.borderColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.25f].CGColor;
    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_vehicleRegImgContainerView edgeInset:UIEdgeInsetsMake(-1.5f, -1.5f, -1.5f, -1.5f) andShadowRadius:5.0f];
    _vehicleRegImgContainerView.layer.shadowPath = shadowPath.CGPath;
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
    [pickersDoneButton addTarget:self action:@selector(donePickerSelectAction:) forControlEvents:UIControlEventTouchUpInside];
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
    [tableDoneButton addTarget:self action:@selector(doneTableSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableDoneButton setTitle:@"Show View" forState:UIControlStateNormal];
    tableDoneButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 40.0);
    tableDoneButton.backgroundColor = [UIColor colorWithRed:35.0/255.0f green:46.0/255.0f blue:66.0/255.0f alpha:0.5f];
    [tableDoneButton setTitle:NSLocalizedString(@"any_done", @"") forState:UIControlStateNormal];
    [tableContainerView addSubview:tableDoneButton];
    //SearchBar
    _tablesSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, tableDoneButton.frame.size.height, self.view.frame.size.width, 40)];
    _tablesSearchBar.delegate = self;
    _tablesSearchBar.showsCancelButton = YES;
    _tablesSearchBar.placeholder = NSLocalizedString(@"personal_search_placeholder", @"");
    [tableContainerView addSubview:_tablesSearchBar];
    //table
    dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableDoneButton.frame.size.height + _tablesSearchBar.frame.size.height, self.view.frame.size.width, 180)];
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    [tableContainerView addSubview:dataTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.applicationDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    datePicketViewShown = NO;
    tableContainerShown = NO;
    
    maxVehicleExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"maxExpiry"] fromFormat:@"YYYY/MM/dd"];
    minVehicleExpiry = [HelperClass convertStringToDate:[self.applicationDelegate.appRules objectForKey:@"minExpiry"] fromFormat:@"YYYY/MM/dd"];
    
    manufacturersArray = [self.applicationDelegate.appRules objectForKey:@"manufacturers"];
    
    yearsArray = [self.applicationDelegate.appRules objectForKey:@"vehicleYears"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self deregisterForKeyboardNotifications];
}
- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processVehicleInfoValidationRequest
{
    NSDictionary *parameters =
    @{
      @"vehicle": @{
              @"isOwnerSelected": ownerSelected ? @"selected" : @"",
              @"isOwner": ownerSelected ? isOwner : @"",
              @"manufacturer" : ((selectedManufacturerCode.length > 0) && selectedManufacturerCode) ? selectedManufacturerCode : @"",
              @"model" : ((selectedModelCode.length > 0) && selectedModelCode) ? selectedModelCode : @"",
              @"plateLetters" : plateLettersText,
              @"plateNumber" : self.plateNumberTF.text,
              @"registrationExpiry" : (selectedvehicleRegExpireDate && selectedvehicleRegExpireDate && ![selectedvehicleRegExpireDate isEqual:[NSNull null]]) ? [NSString stringWithFormat:@"%f", selectedvehicleRegExpireDateInMiliseconds] : @"",
              @"sequenceNumber": self.vehicleRegNumberTF.text,
              @"year": ((selectedYear.length > 0) && selectedYear) ? selectedYear : @""
              }
      };
    NSLog(@"will validate vehicle data : %@", parameters);
    NSDictionary *validation = [ClientSideValidation validateVehicleValidationRequest:[parameters objectForKey:@"vehicle"]];
    
    if([[validation objectForKey:@"isAllValid"] isEqualToString:@"1"]){
        if(self.applicationDelegate.vehicleRegImage){
            NSLog(@"validation passed : %@", validation);
            /* Passed Client-Side validations */
            /* Show loading View */
            
            [self.delegate showRootLoadingView];
            [self.view endEditing:YES];
            NSLog(@"will register data %@", parameters);
            [self performSelectorInBackground:@selector(validateVehicleInfoRequest:) withObject:parameters];
        }else{
            self.vehicleRegImageLabel.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
        }
        
        
    }else{
        NSLog(@"client side validation NOT passed with response : %@", validation);
        [self shakeMissingFields:validation];
    }
}

-(void)validateVehicleInfoRequest:(NSDictionary *)parameters{
    @autoreleasepool {
        BOOL validated = [ServiceManager validateVehicleRequest:parameters :^(NSDictionary *response){
            [self performSelectorOnMainThread:@selector(finishDataValidation:) withObject:response waitUntilDone:NO];
        }];
        if(!validated)
            [self performSelectorOnMainThread:@selector(finishDataValidation:) withObject:nil waitUntilDone:NO];
    }
}
-(void)finishDataValidation:(NSDictionary *)vehicleData
{
    [self.delegate hideRootLoadingView];
    NSLog(@"done personal info validation %@", vehicleData);
    if(vehicleData && [vehicleData objectForKey:@"data"]){
        NSDictionary *requestParameters = [vehicleData objectForKey:@"data"];
        
        [ServiceManager saveTempVehicleInfo:requestParameters];
        [self.delegate goToDocumentsScreen:isOwner andVehicleData:vehicleData];
    }else{
        /* Failed */
        [self serverSideValidation:vehicleData];
    }
}


- (IBAction)chooseManufacturerButtonAction:(UIButton *)sender {
    currentChoosingTable = 0;
    [dataTableView reloadData];
    [self showTableContainer:0 andShow:YES];
}

- (IBAction)chooseModelButtonAction:(UIButton *)sender {
    currentChoosingTable = 1;
    [dataTableView reloadData];
    [self showTableContainer:1 andShow:YES];
}

- (IBAction)chooseYearButtonAction:(UIButton *)sender {
    currentChoosingTable = 2;
    [dataTableView reloadData];
    [self showTableContainer:2 andShow:YES];
}

- (void)showTableContainer:(int)tableToShow andShow:(BOOL)show {
    [self.view endEditing:YES];
    [dataTableView reloadData];
    if(datePicketViewShown)
        [self showHidePickerViewShow:NO];

    tableContainerShown = show;
    [self.delegate addSubView:tableContainerView andShow:show andMoveFooter:NO];
}

#pragma mark - Vehicle Registeration Image

- (IBAction)chooseVehicleRegImgAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
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

#pragma mark - Camera Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSData * pngData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    //Check image size limit (5MB)
    if(((float)[pngData length]/1048576) <= 5){
        // get selected image
        UIImage *imageCaptured = info[UIImagePickerControllerEditedImage];
        
        if(imageCaptured){
            self.applicationDelegate.vehicleRegImage = info[UIImagePickerControllerEditedImage];
            NSLog(@"Vehicle Registeration Image : %@", self.applicationDelegate.vehicleRegImage);
        }
        //Dismiss camera picker controller
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        // Update ID Image Textfield text
        [self.vehicleRegCheckmark setImage:[UIImage imageNamed:@"RegWhiteCheckmark"]];
        self.vehicleRegImageLabel.textColor = [UIColor whiteColor];
    }else{
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_image_size_title", @"") andMessage:NSLocalizedString(@"general_image_size_message", @"")] animated:YES completion:nil];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - Vehicle Registeration DatePicker

- (IBAction)chooseVehicleRegExpiryDate:(UIButton *)sender {
    datePicker.date = [NSDate date];
    
    datePicker.maximumDate = maxVehicleExpiry;
    datePicker.minimumDate = minVehicleExpiry;

    [self showHidePickerViewShow:YES];
}

-(void) showHidePickerViewShow:(BOOL)show{
    if(tableContainerShown)
        [self showTableContainer:0 andShow:NO];
    [self.view endEditing:YES];
    datePicketViewShown = show;
    [self.delegate addSubView:datePickerContainerView andShow:show andMoveFooter:NO];
}


#pragma mark - Owner Check
- (IBAction)ownerSegmentValueChanged:(UISegmentedControl *)sender {
    int selected = [[NSNumber numberWithInteger:sender.selectedSegmentIndex] intValue];
    if(selected == 0){
        isOwner = @"true";
    }else{
        isOwner = @"";
    }
    ownerSelected = YES;
    _ownerNotOwnerLabel.textColor = [UIColor whiteColor];
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    
    selectedvehicleRegExpireDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:sender.date]];
    [_vehicleRegExpireDateBtn setTitle:selectedvehicleRegExpireDateString forState:UIControlStateNormal];
    selectedvehicleRegExpireDate = sender.date;
    selectedvehicleRegExpireDateInMiliseconds = [sender.date timeIntervalSince1970]*1000;
    
    _vehicleRegExpireTop.constant = vehicleExpireConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _vehicleRegExpireDateLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
    
    [_vehicleRegExpireSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_vehicleRegExpireDateBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
}

- (IBAction)doneTableSelectAction:(UIButton *)sender {
    [self showTableContainer:0 andShow:NO];
    [_tablesSearchBar endEditing:YES];
}

- (IBAction)donePickerSelectAction:(UIButton *)sender {
    [self showHidePickerViewShow:NO];
}

#pragma mark - Textfields delegate
-(void)textFieldDidChange:(UITextField *)textField{
    UILabel *currentLabel;
    NSLayoutConstraint *constraint;
    if(textField == _plateNumberTF){
        constraint = _plateNumbersTop;
        constraint.constant = plateLettersConst - 30;
        currentLabel = _plateNumLabel;
    }else if (textField == _plateLettersTF){
        constraint = _plateLettersTop;
        constraint.constant = plateLettersConst - 30;
        currentLabel = _plateLettersLabel;
    }else if (textField == _vehicleRegNumberTF){
        constraint = _vehicleRegTop;
        constraint.constant = vehicleRegConst - 30;
        currentLabel = _vehicleRegLabel;
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.rightViewMode = UITextFieldViewModeNever;
    if(datePicketViewShown)
        [self showHidePickerViewShow:NO];
    if(tableContainerShown)
        [self showTableContainer:0 andShow:NO];
    
    if(textField == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    
    if(textField == _plateNumberTF)
        [_plateNumbersSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(textField == _plateLettersTF)
        [_plateLettersSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(textField == _vehicleRegNumberTF)
        [_vehicleRegSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.plateNumberTF){
        if (textField.text.length > 3 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}
    }
    if(textField == _plateLettersTF){
        if (plateLettersText.length > 2 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {
            if (range.length==1 && string.length==0){
                NSLog(@"backspace tapped");
                plateLettersText = [plateLettersText substringToIndex:[plateLettersText length]-1];
                plateLettersTextSeparated = [plateLettersTextSeparated substringToIndex:[plateLettersTextSeparated length]-2];
                _plateLettersTF.text = plateLettersTextSeparated;
            }else{
                plateLettersText = [NSString stringWithFormat:@"%@%@", plateLettersText, string];
                
                plateLettersTextSeparated = [NSString stringWithFormat:@"%@%@ ",textField.text, string];
                _plateLettersTF.text = plateLettersTextSeparated;
            }
            if(_plateLettersTF.text.length > 0){
                _plateLettersTop.constant = plateLettersConst - 30;
                [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [self.view layoutIfNeeded];
                                     _plateLettersLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                                 }  completion:^(BOOL finished){}];
            }else{
                _plateLettersTop.constant = plateLettersConst;
                [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [self.view layoutIfNeeded];
                                     _plateLettersLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:16];
                                 }  completion:^(BOOL finished){}];
            }
            
            return NO;
        }
    }
    if(textField == self.vehicleRegNumberTF){
        if (textField.text.length > 14 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}
    }
    return YES;
    
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    if(datePicketViewShown){
        [self showHidePickerViewShow:NO];
    }
    if(tableContainerShown){
        [self showTableContainer:0 andShow:NO];
        if(viewSearching)
            [_tablesSearchBar endEditing:YES];
    }
}
#pragma mark - Keyboard Show/Hide Methods
/* Keyboard will show (a textfield became active) */
- (void)keyboardWillShow:(NSNotification*)notification {
    if(viewSearching){
        NSDictionary *info = [notification userInfo];
        /* Get keyboard size */
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [self.delegate moveViewForSearch:kbSize.height andShow:YES];
    }
}

/* Keyboard will hide (active textfield became inactive) */
- (void)keyboardWillHide:(NSNotification*)notification {
    
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
            case 0:
                currentArray = manufacturersArray;
                break;
            case 1:
                currentArray = modelsArray;
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
    [dataTableView reloadData];
    [_tablesSearchBar endEditing:YES];
    [currentSearchingArray removeAllObjects];
    searchBar.text = @"";
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!searching){
        switch (currentChoosingTable) {
            case 0:
                return [manufacturersArray count];
                break;
            case 1:
                return [modelsArray count];
                break;
            case 2:
                return [yearsArray count];
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
        case 0:
            selectedManufacturerCode = [[!(searching) ? manufacturersArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:@"code"];
            [_manufacturerBtn setTitle:[[!(searching) ? manufacturersArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]  forState:UIControlStateNormal];

            modelsArray = [[!(searching) ? manufacturersArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:@"models"];
            selectedModelCode = @"";
            [self selectMan];
            break;
        case 1:
            selectedModelCode = [[!(searching) ? modelsArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:@"code"];
            [_modelBtn setTitle:[[!(searching) ? modelsArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]  forState:UIControlStateNormal];
            [self selectModel];
            break;
        case 2:
            selectedYear = [[!(searching) ? yearsArray : currentSearchingArray objectAtIndex:indexPath.row] stringValue];
            [_yearBtn setTitle:[[!(searching) ? yearsArray : currentSearchingArray objectAtIndex:indexPath.row] stringValue]  forState:UIControlStateNormal];
            [self selectYear];
            break;
            
        default:
            break;
    }
    [self showTableContainer:0 andShow:NO];
    [_tablesSearchBar endEditing:YES];
}

-(void)selectMan{
    [_manSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_manufacturerBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    [_modelBtn setTitle:@""  forState:UIControlStateNormal];
    _manTop.constant = manConst - 30;
    _modelTop.constant = 39;
    
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _manufacturerLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){
                         _modelLabel.text = NSLocalizedString(@"vehicle_model", @"");
                     }];
}

-(void)selectModel{
    [_modelSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_modelBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    
    _modelTop.constant = modelConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _modelLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
                     }  completion:^(BOOL finished){}];
}

-(void)selectYear{
    [_yearSubview setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.5f]];
    if(_yearBtn == currentFieldPopup){
        if(popupViewTag && (popupViewTag > 0)){
            UIView *tempView = [self.view viewWithTag:popupViewTag];
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }
    
    _yearTop.constant = yearConst - 30;
    [UIView animateWithDuration:0.1 delay: 0.0 options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                         _yearLabel.font = [UIFont fontWithName:FONT_ROBOTO_REGULAR size:14];
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
        case 0:
            cellText = [[!(searching) ? manufacturersArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"];
            break;
        case 1:
            cellText = [[!(searching) ? modelsArray : currentSearchingArray objectAtIndex:indexPath.row] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"];
            break;
        case 2:
            cellText = [[!(searching) ? yearsArray : currentSearchingArray objectAtIndex:indexPath.row] stringValue];
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
    if([[fields objectForKey:@"isOwnerSelected"] isEqualToString:@"1"]){
        self.ownerNotOwnerLabel.textColor = [UIColor colorWithRed:247.0/255.0f green:17.0/255.0f blue:94.0/255.0f alpha:1.0f];
    }
    if([[fields objectForKey:@"registrationExpiry"] isEqualToString:@"1"]){
        [self addPopupToField:_vehicleRegExpireDateBtn andMessage:@"Missing Vehicle Registration Expire Date" andSubview:_vehicleRegExpireSubview];
    }
    if([[fields objectForKey:@"sequenceNumber"] isEqualToString:@"1"]){
        [self addPopupToField:_vehicleRegNumberTF andMessage:@"Missing Vehicle Sequence Number" andSubview:_vehicleRegSubview];
    }
    if([[fields objectForKey:@"plateNumber"] isEqualToString:@"1"]){
        [self addPopupToField:_plateNumberTF andMessage:@"Missing Plate Numbers" andSubview:_plateNumbersSubview];
    }
    if([[fields objectForKey:@"plateLetters"] isEqualToString:@"1"]){
        [self addPopupToField:_plateLettersTF andMessage:@"Missing Plate Letters" andSubview:_plateLettersSubview];
    }
    if([[fields objectForKey:@"year"] isEqualToString:@"1"]){
        [self addPopupToField:_yearBtn andMessage:@"Missing Year" andSubview:_yearSubview];
    }
    if([[fields objectForKey:@"model"] isEqualToString:@"1"]){
        [self addPopupToField:_modelBtn andMessage:@"Missing Model" andSubview:_modelSubview];
    }
    if([[fields objectForKey:@"manufacturer"] isEqualToString:@"1"]){
        [self addPopupToField:_manufacturerBtn andMessage:@"Missing Manufacturer" andSubview:_manSubview];
    }
}

-(void)serverSideValidation:(NSDictionary *)errorData{
    if([[errorData objectForKey:@"code"] intValue] == 400){
        NSString *errorField = [[errorData objectForKey:@"error"] objectForKey:@"field"];
        if([errorField isEqualToString:@"plateLetters"]){
            [self addPopupToField:_plateLettersTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_plateLettersSubview];
        }else if([errorField isEqualToString:@"plateNumber"]){
            [self addPopupToField:_plateNumberTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_plateNumbersSubview];
            
        }else if([errorField isEqualToString:@"sequenceNumber"]){
            [self addPopupToField:_vehicleRegNumberTF andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"] andSubview:_vehicleRegSubview];
        }else if([errorField isEqualToString:@"manufacturer"]){
            [self addPopupToField:_manufacturerBtn andMessage:@"Missing Manufacturer" andSubview:_manSubview];
        }else if([errorField isEqualToString:@"model"]){
            [self addPopupToField:_modelBtn andMessage:@"Missing Model" andSubview:_modelSubview];
        }else if([errorField isEqualToString:@"year"]){
            [self addPopupToField:_yearBtn andMessage:@"Missing Year" andSubview:_yearSubview];
        }else if([errorField isEqualToString:@"registrationExpiry"]){
            [self addPopupToField:_vehicleRegExpireDateBtn andMessage:@"Missing Vehicle Registration Expire Date" andSubview:_vehicleRegExpireSubview];
        }else{
            [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"general_problem_title", @"") andMessage:[[errorData objectForKey:@"error"] objectForKey:[[HelperClass getDeviceLanguage] isEqualToString:@"ar"] ? @"ar" : @"en"]] animated:YES completion:nil];
        }
    }else if([[errorData objectForKey:@"code"] intValue] == 409){
        [self presentViewController:[HelperClass showAlert:NSLocalizedString(@"vehicle_already_exists_title", @"") andMessage:NSLocalizedString(@"vehicle_already_exists_message", @"")] animated:YES completion:nil];
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


@end
