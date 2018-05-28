//
//  RegisterationRootViewController.m
//  ProcapDriver
//
//  Created by MacBookPro on 3/8/17.
//  Copyright © 2017 Amer. All rights reserved.
//

#import "RegisterationRootViewController.h"

@interface RegisterationRootViewController ()

@end

@implementation RegisterationRootViewController
@synthesize currentUploadStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Initiate page view controller from storyboard UIPageViewController
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = nil;
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    selectionView = [[UIView alloc] init];
    
    selectionView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    originalSelectionViewFrame = selectionView.frame;
    [self.view addSubview:selectionView];
    
    containerOriginY = self.containerView.frame.origin.y;

    //Change the size of page view controller to fit like containerView
    self.pageViewController.view.frame = self.containerView.bounds;
    [self setScrollEnabled:NO forPageViewController:self.pageViewController];
    
    //Initiate the 3 registeration ViewControllers
    UIStoryboard *projectStoryboard = [UIStoryboard storyboardWithName:@"PreLogin" bundle:[NSBundle mainBundle]];
    
    //ConfirmMobileViewController
    confirmMobile = [projectStoryboard instantiateViewControllerWithIdentifier:@"confirmMobController"];
    confirmMobile.requestParameters = _requestParameters;
    confirmMobile.delegate = self;
    
    //PersonalInfoRegisterationViewController
    personalInfoController = [projectStoryboard instantiateViewControllerWithIdentifier:@"personalInfoController"];
    personalInfoController.delegate = self;
    
    //SecondPersonalViewController
    secondPersonalInfoController = [projectStoryboard instantiateViewControllerWithIdentifier:@"secondPersonalInfoController"];
    secondPersonalInfoController.delegate = self;
    
    //VehicleRegisterViewController
    vehicleInfoController = [projectStoryboard instantiateViewControllerWithIdentifier:@"vehicleInfoController"];
    vehicleInfoController.delegate = self;
    
    //DocumentsRegisterationViewController
    documentsController = [projectStoryboard instantiateViewControllerWithIdentifier:@"documentsController"];
    documentsController.delegate = self;
    
    //DocumentsRegisterationViewController
    documentsProgressController = [projectStoryboard instantiateViewControllerWithIdentifier:@"documentProgress"];
    documentsProgressController.comingFrom = @"start";
    documentsProgressController.delegate = self;
    
    //Controllers array
    myViewControllers = @[confirmMobile, personalInfoController, secondPersonalInfoController, vehicleInfoController, documentsController, documentsProgressController];
    //Current Page index
    pageIndex = CONFIRM_MOBILE_INDEX;
    
    //Pass the first ViewController to UIPageViewController (must be an array)
    UIViewController *startingViewController = [self viewControllerAtIndex:[self checkCurrentStatus]/*FIRST_PERSONAL_INDEX*/];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //Adding PageViewController to the current view
    [self addChildViewController:_pageViewController];
    [self.containerView addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    originalFooterViewY = _footerView.frame.origin.y;

    UIBezierPath *shadowPath = [UIHelperClass setViewShadow:_footerView edgeInset:UIEdgeInsetsMake(-1.0f, -1.0f, -1.0f, -1.0f) andShadowRadius:5.0f];
    _footerView.layer.shadowPath = shadowPath.CGPath;
}


-(int)checkCurrentStatus{
    int index = CONFIRM_MOBILE_INDEX;
    NSLog(@"currentRegStep : %@", [ServiceManager getCurrentRegisterationStep]);
    if([[ServiceManager getCurrentRegisterationStep] isEqualToString:@"vehicle"]){
        index = FIRST_VEHICLE_INDEX;
        [_footerView setHidden:NO];
        //PageControl on vehicle
    }else if([[ServiceManager getCurrentRegisterationStep] isEqualToString:@"uploads"]){
        index = DOCS_PROGRESS_INDEX;
        //PageControl on Documents
        documentsProgressController.comingFrom = @"start";
        [_footerView setHidden:NO];
    }else if([[ServiceManager getCurrentRegisterationStep] isEqualToString:@"all_done"]){
        [self performSegueWithIdentifier:@"GoToGreatings" sender:self];
    }else{
        // TODO check if there's phone seesion
        // AND Not expired
//        NSString *phoneSession = [ServiceManager getPhoneSession];
//        if(phoneSession && (phoneSession.length > 0)){
//            index = FIRST_PERSONAL_INDEX;
//            [self setAllInActive];
//            self.personalInfoIconImgView.image = [UIImage imageNamed:@"Personal_Info_Active-01.png"];
//            [self.personalLabel setTextColor:[UIColor colorWithRed:0.0/255.0f green:152.0/255.0f blue:171.0/255.0f alpha:1.0]];
//        }
    }
    return index;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Method disables UIPageViewController scrolling */
- (void)setScrollEnabled:(BOOL)enabled forPageViewController:(UIPageViewController*)pageViewController
{
    for (UIView *view in pageViewController.view.subviews) {
        if ([view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            [scrollView setScrollEnabled:enabled];
            return;
        }
    }
}

/* Method returns the next ViewController to display */
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([myViewControllers count] == 0) || (index >= [myViewControllers count])) {
        return nil;
    }
    pageIndex = index;
    NSLog(@"viewControllerAtIndex index : %ld", (long)pageIndex);
    
    [_footerView setHidden:NO];
    //TODO
    //PageControl Work
    switch (pageIndex) {
        case 0:
            _titleLabel.text = @"";
            [_footerView setHidden:YES];
            break;
        case 1:
            _titleLabel.text = @"Personal Info";
            break;
        case 2:
            _titleLabel.text = @"Personal Info";
            break;
        case 3:
            _titleLabel.text = @"Vehicle Info";
            break;
        case 4:
            _titleLabel.text = @"Vehicle Info";
            break;
        case 5:
            _titleLabel.text = @"Attachments";
            break;
            
        default:
            break;
    }
    return [myViewControllers objectAtIndex:index];
}

#pragma mark - Popups
-(void)addSubView:(UIView *)viewToAdd andShow:(BOOL)show andMoveFooter:(BOOL)footer
{
    if(show){
        viewToAdd.frame = selectionView.bounds;
        [selectionView addSubview:viewToAdd];
        [selectionView bringSubviewToFront:viewToAdd];
        selectionView.backgroundColor = [UIColor yellowColor];
        if(footer)
            self.containerViewConstraint.constant = -containerOriginY;
            
        [UIView animateWithDuration:0.5f animations:^{
            if(footer)
                [self.view layoutIfNeeded];
            
            selectionView.frame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height - selectionView.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
        } completion:^(BOOL finished){ }];
        
    }else{
        if(self.containerViewConstraint.constant < 0)
            self.containerViewConstraint.constant = 0;
        [UIView animateWithDuration:0.5f animations:^{
                [self.view layoutIfNeeded];
            
            selectionView.frame = CGRectMake(selectionView.frame.origin.x, self.view.frame.size.height, selectionView.frame.size.width, selectionView.frame.size.height);
            
        } completion:^(BOOL finished){ }];
    }
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [myViewControllers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - PageViewController Navigation
/* Method takes ViewController and direction to navigate to it */
-(void)moveToPageAtIndex:(NSUInteger)index andDirection:(UIPageViewControllerNavigationDirection )direction
{
    UIViewController *currentViewController = [self viewControllerAtIndex:index];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:direction animated:YES completion:nil];
}

#pragma mark - EnterMobile Delegate
-(void)moveToConfirmController:(NSDictionary *)parameters
{
    confirmMobile = (ConfirmMobileViewController *)[self viewControllerAtIndex:CONFIRM_MOBILE_INDEX];
    confirmMobile.requestParameters = parameters;
    NSArray *viewControllers = @[confirmMobile];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
//    self.pageIndicator.currentPage = CONFIRM_MOBILE_INDEX;
}

#pragma mark - Confirm Mobile Controller Delegate
-(void)moveToRegisterController:(NSString *)phoneNumber andOTPCode:(NSString *)otpCode
{
    [self moveToPageAtIndex:FIRST_PERSONAL_INDEX andDirection:UIPageViewControllerNavigationDirectionForward];
    
    personalInfoController = (PersonalInfoRegisterationViewController *)[self viewControllerAtIndex:FIRST_PERSONAL_INDEX];
    NSLog(@"should go %@ - %@", phoneNumber, otpCode);
    personalInfoController.phoneNumber = phoneNumber;
    personalInfoController.otpCode = otpCode;
    NSLog(@"should go %@ - %@", personalInfoController.phoneNumber, personalInfoController.otpCode);
    NSArray *viewControllers = @[personalInfoController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
//    self.pageIndicator.currentPage = FIRST_PERSONAL_INDEX;
}


#pragma mark - Personal Info Controller Delegate
-(void)goToGeneralInfoRegisteration:(NSDictionary *)firstInfo andPhone:(NSString *)phone andOTP:(NSString *)otpCode
{
    secondPersonalInfoController = (SecondPersonalViewController *)[self viewControllerAtIndex:SECOND_PERSONAL_INDEX];
    secondPersonalInfoController.phoneNumber = phone;
    secondPersonalInfoController.otpCode = otpCode;

    NSArray *viewControllers = @[secondPersonalInfoController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - SecondPersonalInfoController Delegate
-(void)goToVehicleRegisteration{
    vehicleInfoController = (VehicleRegisterViewController *)[self viewControllerAtIndex:FIRST_VEHICLE_INDEX];
    NSArray *viewControllers = @[vehicleInfoController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}


#pragma mark - VehicleInfoViewController Delegate

-(void)goToDocumentsScreen:(NSString *)isOwner andVehicleData:(NSDictionary *)vehicleData{
    documentsController = (DocumentsRegisterationViewController *)[self viewControllerAtIndex:SECOND_VEHICLE_INDEX];
//    documentsController.owner = isOwner;
//    documentsController.vehicleData = vehicleData;
    NSArray *viewControllers = @[documentsController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - DocumentsViewController Delegate

-(void)goToDocumentsProgressScreenWithVehicleData:(NSString *)comingFrom{
    documentsProgressController = (DocumentsProgressViewController *)[self viewControllerAtIndex:DOCS_PROGRESS_INDEX];
    documentsProgressController.comingFrom = comingFrom;
    NSArray *viewControllers = @[documentsProgressController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

-(void)addExperienceView:(UIView *)expView{
    NSLog(@"expView : %@", expView);
    [expView removeFromSuperview];
    expView.frame = self.view.bounds;
//    expView.alpha = 0.0f;
    [self.view addSubview:expView];
    [self.view bringSubviewToFront:expView];
//    [UIView animateWithDuration:0.3 delay: 0.0 options: UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         expView.alpha = 1.0f;
//                     } completion:^(BOOL finished){}];
    
}

#pragma mark - DocumentProgressController Delegate
-(void)hideFooterView{
    self.footerView.hidden = YES;
}


#pragma mark - Common delegate methods between all child controllers (Show/Hide Loading View)

-(void)showRootLoadingView{
    [self showLoadingView:YES];
}
-(void)hideRootLoadingView{
    [self showLoadingView:NO];
}


#pragma mark - Back Action
/*
 Method handles which controller to be called when user clicks on NEXT button
 */
- (IBAction)childControllerNextActions:(UIButton *)sender {
    
    // Check where we are
    switch (pageIndex) {
        case 1:
            [personalInfoController processPersonalInfoValidationRequest];
            break;
        case 2:
            [secondPersonalInfoController processCompletePersonalInfoRequest];
            break;
        case 3:
            [vehicleInfoController processVehicleInfoValidationRequest];
            break;
        case 4:
            [documentsController processCompleteVehicleRequest];
            break;
        case 5:

            break;
            
        default:
            break;
    }
    
}

- (IBAction)backAction:(UIButton *)sender {
    int goStatus = 0;
    NSUInteger index = pageIndex;
    
    switch (pageIndex) {
        case 0:
            //If current page index == 0, Back To Login
//            directReturnToLogin = YES;
            goStatus = 0;
            break;
        case 1:
            //If current page index == 1, Back To Login
            goStatus = 2;
            index --;
            break;
        case 2:
            //If current page index == 2, In SecondPersonalInfo Should return to first PersonalInfoViewController
            index --;
            goStatus = 1;
            break;
        case 3:
            //If current page index == 3, In VehicleFirstController Should return to Login
            goStatus = 2;
            break;
        case 4:
            //In Vehicle Second Screen, In VehicleSecondScreen Should return to first VehicleFirstScreen
            index --;
            goStatus = 1;
            break;
        case 5:
            //If current page index == 2, In Docs Progress Screen, Should go back to login
            goStatus = 2;
            break;
            
        default:
            break;
    }
    //GoStatus --- 0=returnLogin  ---- 1=oneBackStep ---- 2=AlertForUnsavedData
    switch (goStatus) {
        case 0:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 1:
            [self moveToPageAtIndex:index andDirection:UIPageViewControllerNavigationDirectionReverse];
            break;
        case 2:
            [self showAlert];
            break;
            
        default:
            break;
    }
    
}
-(void)showAlert{
    UIAlertController * alert=[UIAlertController
                               
                               alertControllerWithTitle:NSLocalizedString(@"root_back_warning_title", @"") message:NSLocalizedString(@"toor_back_warning_message", @"")preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirmBtn = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"root_back_warning_done", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
    
    UIAlertAction *cancelBtn = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"root_back_warning_cancel", @"")
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction:confirmBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - LoadingView
-(void)showLoadingView:(BOOL)show{
    if(show){
        [loadingView removeFromSuperview];
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.8;
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = loadingView.center;
        indicator.color = [UIColor whiteColor];
        [indicator startAnimating];
        [loadingView addSubview:indicator];
        
        [self.view addSubview:loadingView];
        [self.view bringSubviewToFront:loadingView];
    }else
        [loadingView removeFromSuperview];
    
}

#pragma mark - Hide Keyboard when click anywhere
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}

#pragma mark - Move Footer Veiw while (Enter Mobile) keyboard is shown

-(void)moveFooterView:(float)newY{
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.view.frame.size.height - self.footerView.frame.size.height + newY, self.footerView.frame.size.width, self.footerView.frame.size.height);
    
}

-(void)moveViewForTextFields:(float)newY andShow:(BOOL)show{
    if(show){
        //This was self.view not self.containerView
        if(self.containerViewConstraint.constant == 0){
            self.containerViewConstraint.constant = -newY;
            [UIView animateWithDuration:0.5f animations:^{
                [self.view layoutIfNeeded];
                
            }];
        }
        
    }else{
        if(self.containerViewConstraint.constant < 0){
            self.containerViewConstraint.constant = 0;
            [UIView animateWithDuration:0.3f animations:^{
                [self.view layoutIfNeeded];
                
            }];
        }
    }
}
-(void)moveViewForSearch:(float)newY andShow:(BOOL)show{
    if(show){
        //This was self.view not self.containerView
//        self.containerViewConstraint.constant = -newY;
        [UIView animateWithDuration:0.5f animations:^{
            selectionView.frame = CGRectMake(0, selectionView.frame.origin.y - newY, self.view.frame.size.width, selectionView.frame.size.height);
//            [self.view layoutIfNeeded];
        }];
        
    }else{
//        self.containerViewConstraint.constant = 0;
        [UIView animateWithDuration:0.3f animations:^{
            selectionView.frame = originalSelectionViewFrame;
//            [self.view layoutIfNeeded];
        }];
        
    }
}
@end
