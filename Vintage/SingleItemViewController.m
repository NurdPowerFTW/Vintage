//
//  SingleItemViewController.m
//  Vintage
//
//  Created by William on 5/18/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "SingleItemViewController.h"
#import "SingleItemTableViewCell.h"
#import "singleEventDescriptionCell.h"
#import <AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "VintageApiService.h"
#import "HexColors.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation SingleItemViewController 

-(void)viewDidLoad
{
   [super viewDidLoad];
   self.contactTextField.delegate = self;
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification object:nil];
   
   [self.view bringSubviewToFront:self.bottomBarView];
   [self.view bringSubviewToFront:self.notificationView];
   self.contactTextField.floatingLabelActiveTextColor = [UIColor blueColor];
   self.contactTextField.floatingLabelInactiveTextColor = [UIColor grayColor];
   self.contactTextField.animationDirection = RPFloatingPlaceholderAnimateDownward;
   self.contactTextField.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
   self.contactTextField.placeholder = NSLocalizedString(@"輸入您的信箱或電話", nil);
   self.contactTextField.font = [UIFont systemFontOfSize:14];
   
   
   self.contextTextView.floatingLabelActiveTextColor = [UIColor blueColor];
   self.contextTextView.floatingLabelInactiveTextColor = [UIColor grayColor];
   self.contextTextView.animationDirection = RPFloatingPlaceholderAnimateDownward;
   self.contextTextView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
   self.contextTextView.placeholder = NSLocalizedString(@"輸入留言與建議", nil);
   self.contextTextView.font = [UIFont systemFontOfSize:14];
   
   selected = NO;
   self.notificationView.hidden = YES;
   self.titleLabel.text = self.twTitleString;
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onSetCollectionNotification:) name:SetCollectionNotification object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onSendMessageNotification:) name:sendMessageNotification object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCancelCollectionNotification:) name:CancelCollectionNotification object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFetchingCollectionInfoNotification:) name:FetchingCollectionInfoNotification object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onUpdatePointListNotification:) name:updatePointsListNotification object:nil];
   [[VintageApiService sharedInstance]fetchCollectionInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] keyword:[self.selectedWineInfoDictionary objectForKey:@"subtitle_tw"]];
   self.queryPopUpView.hidden = YES;
   self.sharePopUpView.hidden = YES;
   
   UITapGestureRecognizer* cancelPopUpViewRecog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPopUpView:)];
   [self.view addGestureRecognizer:cancelPopUpViewRecog];
   [self.queryPopUpView removeGestureRecognizer:cancelPopUpViewRecog];
   UITapGestureRecognizer* cancelContactKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelContactKey:)];
   [self.queryPopUpView addGestureRecognizer:cancelContactKeyBoard];
}
- (void)cancelContactKey:(UITapGestureRecognizer *)recog
{
   [self.view endEditing:YES];
}
- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
   return YES;
}
- (void)onUpdatePointListNotification:(NSNotification*)notify
{
   if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"18"])
   {
      maskView.hidden = YES;
      [self resultPopUpView:[notify.object objectForKey:@"point"]];
      [[NSUserDefaults standardUserDefaults]setObject:[notify.object objectForKey:@"point_sum"] forKey:@"point_sum"];
      [[NSUserDefaults standardUserDefaults]synchronize];
      [[NSNotificationCenter defaultCenter]postNotificationName:RefreshPersonalInfoNotification object:nil];
   }
   else
   {
      maskView.hidden = YES;
      SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
      [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
      [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
      [alert showCustom:[UIImage imageNamed:@"img_x"] color:[UIColor colorWithHexString:@"a71645"] title:NSLocalizedString(@"您已分享過此商品", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
   }
}

- (IBAction)removeSharePopUpView:(id)sender {
    self.sharePopUpView.hidden = YES;
    maskView.hidden = YES;
}

- (void)onFetchingCollectionInfoNotification:(NSNotification*)notify
{
   if ([[[[notify.object objectForKey:@"wines"] objectAtIndex:1] objectForKey:@"is_liked"]isEqual:[NSNull null]])
   {
      self.likeButtonImageView.image = [UIImage imageNamed:@"btn_like_normal"];
      selected = NO;
      
   }
   else
   {
      self.likeButtonImageView.image = [UIImage imageNamed:@"btn_like_selected"];
      selected = YES;
   }
}
- (void)onSendMessageNotification:(NSNotification*)notify
{
   if ([[notify.object objectForKey:@"ERR_CODE"]isEqualToString:@"17"])
   {
      SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
      [alert showSuccess:NSLocalizedString(@"留言發送成功", nil) subTitle:NSLocalizedString(@"按下確定回到畫面", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
   }
   else
   {
      SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
      
      [alert showWarning:self title:NSLocalizedString(@"留言發送失敗", nil) subTitle:NSLocalizedString(@"請重試", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
   }
   
   
}
- (void)onCancelCollectionNotification:(NSNotification*)notify
{
   NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
   [defaults setObject:@"on" forKey:@"setCollection"];
   [defaults synchronize];
   self.notificationView.hidden = NO;
   self.notificationLabel.text = NSLocalizedString(@"成功取消收藏", nil);
   self.notificationView.backgroundColor = [self drawGradientLineWithRGB:0 green:0 blue:0 alpha:0.6];
   UIBezierPath *maskPath;
   maskPath = [UIBezierPath bezierPathWithRoundedRect:self.notificationView.bounds
                                    byRoundingCorners:(UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                          cornerRadii:CGSizeMake(5.0f, 5.0f)];
   
   CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
   maskLayer.frame = self.notificationView.bounds;
   maskLayer.path = maskPath.CGPath;
   self.notificationView.layer.mask = maskLayer;
   
   [NSTimer scheduledTimerWithTimeInterval:1.0
                                    target:self
                                  selector:@selector(removeNotification:)
                                  userInfo:nil
                                   repeats:NO];
   
}
- (void)onSetCollectionNotification:(NSNotification*)notify
{
   NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
   [defaults setObject:@"on" forKey:@"setCollection"];
   [defaults synchronize];
   self.notificationView.hidden = NO;
   self.notificationLabel.text = NSLocalizedString(@"成功加入收藏", nil);
   self.notificationView.backgroundColor = [self drawGradientLineWithRGB:0 green:0 blue:0 alpha:0.6];
   UIBezierPath *maskPath;
   maskPath = [UIBezierPath bezierPathWithRoundedRect:self.notificationView.bounds
                                    byRoundingCorners:(UIRectCornerTopRight|UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                          cornerRadii:CGSizeMake(5.0f, 5.0f)];
   
   CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
   maskLayer.frame = self.notificationView.bounds;
   maskLayer.path = maskPath.CGPath;
   self.notificationView.layer.mask = maskLayer;
   
   [NSTimer scheduledTimerWithTimeInterval:1.0
                                    target:self
                                  selector:@selector(removeNotification:)
                                  userInfo:nil
                                   repeats:NO];
   
}
- (UIColor*)drawGradientLineWithRGB:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
   return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}
- (IBAction)shareAction:(id)sender {
   if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Facebook"])
   {
      self.fbShareButton.enabled =YES;
      self.wbShareButton.enabled = YES;
      [self popShareView];
   }
   else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"]isEqualToString:@"Weibo"])
      
   {
      self.wbShareButton.enabled = YES;
      self.fbShareButton.enabled =YES;
      [self popShareView];
   }
   else
   {
      /*SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
      [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
      [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
      [alert showWarning:self title:NSLocalizedString(@"請先登入", nil) subTitle:NSLocalizedString(@"登入後才能使用此功能", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];*/
      self.wbShareButton.enabled = YES;
      self.fbShareButton.enabled =YES;
      [self popShareView];
   }
    

}
- (IBAction)likeAction:(id)sender {
   if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoginType"])
   {
      if (selected == NO) {
         
         [[VintageApiService sharedInstance]setCollectionListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] wine_id:[self.selectedWineInfoDictionary objectForKey:@"id"]];
         self.likeButtonImageView.image = [UIImage imageNamed:@"btn_like_selected"];
         [self.notificationButton setSelected:NO];
         [self.view setUserInteractionEnabled:NO];
         selected = YES;
      }
      else
      {
         
         [[VintageApiService sharedInstance]cancelCollectionListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] wine_ids:[self.selectedWineInfoDictionary objectForKey:@"id"]];
         NSLog(@"selectedWineInfoDictionary id:%@",[self.selectedWineInfoDictionary objectForKey:@"id"]);
         self.likeButtonImageView.image = [UIImage imageNamed:@"btn_like_normal"];
         [self.notificationButton setSelected:YES];
         [self.view setUserInteractionEnabled:NO];
         selected = NO;
      }
   }
   else
   {
      SCLAlertView *alert = [[SCLAlertView alloc] init];
      [alert setTitleFontFamily:@"Superclarendon" withSize:12.0f];
      [alert showWarning:self title:NSLocalizedString(@"請先登入", nil) subTitle:NSLocalizedString(@"登入後才能使用此功能", nil) closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
   }
   
   
}
- (void)removeNotification:(id)sender
{
   self.notificationView.hidden = YES;
   [self.view setUserInteractionEnabled:YES];
}
- (IBAction)backAction:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
}
- (float)calculateNameTextViewHeight:(NSString*)text
{
   UITextView *textView = [[UITextView alloc] init];
   NSString* title =text;
   [textView setText:title];
   [textView sizeToFit];
   CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width * 0.41, FLT_MAX)];
   return size.height;
}

- (float)calculateSubNameTextViewHeight:(NSString*)text
{
   UITextView *textView = [[UITextView alloc] init];
   NSString* title =text;
   [textView setText:title];
   [textView sizeToFit];
   CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width *0.41, FLT_MAX)];
   NSLog(@"subname height:%f",size.height);
   return size.height;
}

- (float)calculatePriceTextViewHeight:(NSString*)text
{
   UILabel *priceLabel = [[UILabel alloc]init];
   NSString *title = text;
   [priceLabel setText:title];
   [priceLabel sizeToFit];
   CGSize size = [priceLabel sizeThatFits:CGSizeMake(FLT_MAX,self.view.frame.size.height * 0.04)];
   
   return size.height+ self.view.frame.size.height * 0.088;
}

- (float)calculateDescritionTextViewHeight:(NSString*)text
{
   UITextView *textView = [[UITextView alloc] init];
   NSString* title =text;
   [textView setText:title];
   [textView sizeToFit];
   CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width *0.8, FLT_MAX)];
   NSLog(@"subname height:%f",size.height);
   return size.height;
}
- (float)textWrapperViewHeight:(NSString*)title subTitle:(NSString*)subTitle price:(NSString*)price producer:(NSString*)producer
{
   return [self calculateNameTextViewHeight:title] + [self calculateSubNameTextViewHeight:subTitle] + [self calculatePriceTextViewHeight:price] + [self calculateNameTextViewHeight:producer];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == 0)
   {
      return self.view.frame.size.height * 0.62;
   }
   else if (indexPath.row == 1)
   {
      return [self calculateDescritionTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content1_tw"]] + self.view.frame.size.height * 0.07f;
   }
   else if (indexPath.row == 2)
   {
      return [self calculateDescritionTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content2_tw"]]+ self.view.frame.size.height * 0.07f;
   }
   else
   {
      return  [self calculateDescritionTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content3_tw"]]+ self.view.frame.size.height *0.26f;
   }
}

- (float)calculateTextViewHeight:(NSString*)text
{
   UITextView *textView = [[UITextView alloc] init];
   NSString* title =text;
   [textView setText:title];
   [textView sizeToFit];
   CGSize size = [textView sizeThatFits:CGSizeMake(self.view.frame.size.width * 0.73125, FLT_MAX)];
   float totalHeight = size.height+ self.view.frame.size.height * 0.0775;
   NSLog(@"size.height:%f",totalHeight);
   return size.height+ self.view.frame.size.height * 0.088;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
   float superViewWidth = self.view.frame.size.width;
   float superViewHeight = self.view.frame.size.height;
   
   if (indexPath.row == 0)
   {
      static NSString *cellIdentifier = @"SingleItemTableViewCell";
      SingleItemTableViewCell* cell;
      cell = (SingleItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (!cell)
      {
         if (!self.CellNib)
         {
            self.CellNib = [UINib nibWithNibName:@"SingleItemTableViewCell" bundle:nil];
            
         }
         NSArray* bundleObjects = [self.CellNib instantiateWithOwner:self options:nil];
         cell = [bundleObjects objectAtIndex:0];
      }
      UITextView *title = [[UITextView alloc]initWithFrame:CGRectMake(0, 0 , superViewWidth*0.41, [self calculateNameTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"title_tw"]])];
      if ([language isEqualToString:@"en"]) {
         title.text = [self.selectedWineInfoDictionary objectForKey:@"title_en"];
      }
      else if ([language isEqualToString:@"zh-Hans"])
      {
         title.text = [self.selectedWineInfoDictionary objectForKey:@"title_cn"];
      }
      else
      {
         title.text = [self.selectedWineInfoDictionary objectForKey:@"title_tw"];
      }
      
      title.font = [UIFont systemFontOfSize:18];
      title.textColor = [UIColor blackColor];
      title.editable = NO;
      title.scrollEnabled = NO;
      [title sizeToFit];
      
      
      NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.productImageString]];
      AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
      requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
      [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         cell.itemImageView.image = [self scaleAndRotateImage:responseObject];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
      }];
      [requestOperation start];
      //cell.itemImageView.backgroundColor = [UIColor blueColor];
      UITextView *subTitle = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame) -10 , superViewWidth*0.41, [self calculateSubNameTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"serial_num"]])];
      if ([language isEqualToString:@"en"]) {
         subTitle.text = [self.selectedWineInfoDictionary objectForKey:@"serial_num"];
      }
      else if ([language isEqualToString:@"zh-Hans"])
      {
         subTitle.text = [self.selectedWineInfoDictionary objectForKey:@"serial_num"];
      }
      else
      {
         subTitle.text = [self.selectedWineInfoDictionary objectForKey:@"serial_num"];
      }
      subTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
      subTitle.textColor = [UIColor colorWithHexString:@"c12558"];
      subTitle.editable = NO;
      subTitle.scrollEnabled = NO;
      [subTitle sizeToFit];
      
      
      UIView * priceWrapperView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subTitle.frame) , [self calculatePriceTextViewHeight:self.priceString], self.view.frame.size.height * 0.04)];
      priceWrapperView.backgroundColor = [UIColor darkGrayColor];
      priceWrapperView.layer.cornerRadius = 10;
      priceWrapperView.layer.masksToBounds = YES;
      UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, [self calculatePriceTextViewHeight:[NSString stringWithFormat:@"NT$%@", self.priceString]], self.view.frame.size.height * 0.04)];
      priceLabel.text = [NSString stringWithFormat:@"NT$%@", self.priceString];
      priceLabel.font = [UIFont systemFontOfSize:12];
      priceLabel.textColor = [UIColor whiteColor];
      //priceLabel.backgroundColor = [UIColor blueColor];
      [priceLabel sizeToFit];
      [priceLabel setCenter:CGPointMake(priceWrapperView.frame.size.width/2, priceWrapperView.frame.size.height/2)];
      [priceWrapperView addSubview:priceLabel];
      //[textWrapperView addSubview:priceWrapperView];
      
      UITextView *producerName = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMinX(subTitle.frame), CGRectGetMaxY(priceWrapperView.frame), superViewWidth*0.41,  [self calculateNameTextViewHeight:self.manufactureString])];
      
      producerName.text = self.manufactureString;
      [UIFont systemFontOfSize:12];
      producerName.textColor = [UIColor blackColor];
      producerName.textAlignment = NSTextAlignmentNatural;
      producerName.editable = NO;
      producerName.scrollEnabled = NO;
      [producerName sizeToFit];
      
      UIView *textWrapperView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.itemImageView.frame)+superViewWidth * 0.03, superViewHeight *0.3
                                                                        , superViewWidth*0.45,CGRectGetMaxY(producerName.frame) - CGRectGetMinY(title.frame) )];
      [textWrapperView addSubview:title];
      [textWrapperView addSubview:subTitle];
      [textWrapperView addSubview:priceWrapperView];
      [textWrapperView addSubview:producerName];
      [cell addSubview:textWrapperView];
      
      
      return cell;
   }
   else
   {
      
      static NSString *cellIdentifier = @"singleEventDescriptionCell";
      singleEventDescriptionCell* cell;
      cell = (singleEventDescriptionCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (!cell)
      {
         if (!self.CellNib2)
         {
            self.CellNib2 = [UINib nibWithNibName:@"singleEventDescriptionCell" bundle:nil];
            
         }
         NSArray* bundleObjects = [self.CellNib2 instantiateWithOwner:self options:nil];
         cell = [bundleObjects objectAtIndex:0];
      }
      if (indexPath.row == 1)
      {
         cell.titleLabel.hidden = YES;
         cell.subTitle.hidden = YES;
         
         UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.14, superViewHeight * 0.021, superViewWidth *0.23, superViewHeight * 0.032)];
         if ([language isEqualToString:@"en"])
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title1_en"];
         }
         else if ([language isEqualToString:@"zh-Hans"])
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title1_cn"];
         }
         else
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title1_tw"];
         }

         
         [cell addSubview:title];
         
         UITextView *descriptionText = [[UITextView alloc]initWithFrame:CGRectMake(superViewWidth * 0.13, superViewHeight * 0.07, superViewWidth * 0.8, [self calculateSubNameTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content1_tw"]])];
         if ([language isEqualToString:@"en"])
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content1_en"];
         }
         else if ([language isEqualToString:@"zh-Hans"])
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content1_cn"];
         }
         else
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content1_tw"];
         }
         descriptionText.font = [UIFont systemFontOfSize:12];
         descriptionText.textColor = [UIColor colorWithHexString:@"948d8d"];
         descriptionText.editable = NO;
         descriptionText.scrollEnabled = NO;
         [descriptionText sizeToFit];
         [cell addSubview:descriptionText];
         
         UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(superViewWidth * 0.044, superViewHeight * 0.021, superViewWidth * 0.056, superViewWidth * 0.056)];
         
         outerRingView.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:0.7];
         outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
         outerRingView.layer.masksToBounds = YES;
         [cell addSubview:outerRingView];
         
         UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
         innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
         innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
         innerRingView.layer.masksToBounds = YES;
         innerRingView.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:1.0];
         [outerRingView addSubview:innerRingView];
         
         UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content1_tw"]]-CGRectGetMaxY(outerRingView.frame))];
         gradientLineBottom.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:1.0];
         [cell addSubview:gradientLineBottom];
         return cell;
      }
      else if (indexPath.row == 2)
      {
         cell.titleLabel.hidden = YES;
         cell.subTitle.hidden = YES;
         
         UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.14, superViewHeight * 0.021, superViewWidth *0.23, superViewHeight * 0.032)];
         if ([language isEqualToString:@"en"])
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title2_en"];
         }
         else if ([language isEqualToString:@"zh-Hans"])
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title2_cn"];
         }
         else
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title2_tw"];
         }
         [cell addSubview:title];
         
         UITextView *descriptionText = [[UITextView alloc]initWithFrame:CGRectMake(superViewWidth * 0.13, superViewHeight * 0.07, superViewWidth * 0.8, [self calculateSubNameTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content2_tw"]])];
         if ([language isEqualToString:@"en"])
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content2_en"];
         }
         else if ([language isEqualToString:@"zh-Hans"])
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content2_cn"];
         }
         else
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content2_tw"];
         }
         descriptionText.font = [UIFont systemFontOfSize:12];
         descriptionText.textColor = [UIColor colorWithHexString:@"948d8d"];
         descriptionText.editable = NO;
         descriptionText.scrollEnabled = NO;
         [descriptionText sizeToFit];
         [cell addSubview:descriptionText];
         
         UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(superViewWidth * 0.044, superViewHeight * 0.021, superViewWidth * 0.056, superViewWidth * 0.056)];
         
         outerRingView.backgroundColor = [UIColor colorWithRed:89/255.0 green:27/255.0 blue:72/255.0 alpha:0.7];
         outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
         outerRingView.layer.masksToBounds = YES;
         [cell addSubview:outerRingView];
         
         UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
         innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
         innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
         innerRingView.layer.masksToBounds = YES;
         innerRingView.backgroundColor = [UIColor colorWithRed:89/255.0 green:27/255.0 blue:72/255.0 alpha:1.0];
         [outerRingView addSubview:innerRingView];
         
         UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, CGRectGetMinY(outerRingView.frame))];
         gradientLineTop.backgroundColor = [UIColor colorWithRed:167/255.0 green:22/255.0 blue:69/255.0 alpha:1.0];
         [cell addSubview:gradientLineTop];
         UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content2_tw"]]-CGRectGetMaxY(outerRingView.frame))];
         gradientLineBottom.backgroundColor = [UIColor colorWithRed:89/255.0 green:27/255.0 blue:72/255.0 alpha:1.0];
         [cell addSubview:gradientLineBottom];
         return cell;
      }
      else
      {
         cell.titleLabel.hidden = YES;
         cell.subTitle.hidden = YES;
         
         UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(superViewWidth * 0.14, superViewHeight * 0.021, superViewWidth *0.23, superViewHeight * 0.032)];
         if ([language isEqualToString:@"en"])
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title3_en"];
         }
         else if ([language isEqualToString:@"zh-Hans"])
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title3_cn"];
         }
         else
         {
            title.text = [self.selectedWineInfoDictionary objectForKey:@"title3_tw"];
         }
         
         UITextView *descriptionText = [[UITextView alloc]initWithFrame:CGRectMake(superViewWidth * 0.13, superViewHeight * 0.07, superViewWidth * 0.8, [self calculateSubNameTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content3_tw"]])];
         if ([language isEqualToString:@"en"])
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content3_en"];
         }
         else if ([language isEqualToString:@"zh-Hans"])
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content3_cn"];
         }
         else
         {
            descriptionText.text = [self.selectedWineInfoDictionary objectForKey:@"content3_tw"];
         }
         descriptionText.font = [UIFont systemFontOfSize:12];
         descriptionText.textColor = [UIColor colorWithHexString:@"948d8d"];
         descriptionText.editable = NO;
         descriptionText.scrollEnabled = NO;
         [descriptionText sizeToFit];
         [cell addSubview:descriptionText];
         
      
        
         UIView *outerRingView = [[UIView alloc]initWithFrame:CGRectMake(superViewWidth * 0.044, superViewHeight * 0.021, superViewWidth * 0.056, superViewWidth * 0.056)];
         
         outerRingView.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:0.7];
         outerRingView.layer.cornerRadius = outerRingView.bounds.size.width/2;
         outerRingView.layer.masksToBounds = YES;
         [cell addSubview:outerRingView];
         
         UIView *innerRingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, outerRingView.frame.size.width * 2/3, outerRingView.frame.size.width * 2/3)];
         innerRingView.center = CGPointMake(outerRingView.frame.size.width  / 2, outerRingView.frame.size.height / 2);
         innerRingView.layer.cornerRadius = innerRingView.bounds.size.width/2;
         innerRingView.layer.masksToBounds = YES;
         innerRingView.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:1.0];
         [outerRingView addSubview:innerRingView];
         UIView *gradientLineTop = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), 0, 1, CGRectGetMinY(outerRingView.frame))];
         gradientLineTop.backgroundColor = [UIColor colorWithRed:89/255.0 green:27/255.0 blue:72/255.0 alpha:1.0];
         [cell addSubview:gradientLineTop];
         UIView *gradientLineBottom = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(outerRingView.frame), CGRectGetMaxY(outerRingView.frame), 1, [self calculateTextViewHeight:[self.selectedWineInfoDictionary objectForKey:@"content3_tw"]]-CGRectGetMaxY(outerRingView.frame))];
         gradientLineBottom.backgroundColor = [UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:1.0];
         [cell addSubview:gradientLineBottom];
         [cell addSubview:title];
         UIView *bottomDot = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(gradientLineBottom.frame), CGRectGetMaxY(gradientLineBottom.frame), 7, 7)];
         bottomDot.layer.cornerRadius = bottomDot.bounds.size.width/2;
         bottomDot.layer.masksToBounds = YES;
         [bottomDot setCenter:CGPointMake(CGRectGetMidX(gradientLineBottom.frame), CGRectGetMaxY(gradientLineBottom.frame))];
         bottomDot.backgroundColor =[UIColor colorWithRed:75/255.0 green:4/255.0 blue:105/255.0 alpha:1.0];
         [cell addSubview:bottomDot];
         return cell;
      }
   }
}
- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
   NSLog(@"scaleAndRotateImage");
   int kMaxResolution = 300; // Or whatever
   
   CGImageRef imgRef = image.CGImage;
   
   CGFloat width = CGImageGetWidth(imgRef);
   CGFloat height = CGImageGetHeight(imgRef);
   
   
   CGAffineTransform transform = CGAffineTransformIdentity;
   CGRect bounds = CGRectMake(0, 0, width, height);
   if (width > kMaxResolution || height > kMaxResolution)
   {
      CGFloat ratio = width/height;
      if (ratio > 1) {
         bounds.size.width = kMaxResolution;
         bounds.size.height = roundf(bounds.size.width / ratio);
      }
      else {
         bounds.size.height = kMaxResolution;
         bounds.size.width = roundf(bounds.size.height * ratio);
      }
   }
   
   CGFloat scaleRatio = bounds.size.width / width;
   CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
   CGFloat boundHeight;
   UIImageOrientation orient = image.imageOrientation;
   switch(orient)
   {
         
      case UIImageOrientationUp: //EXIF = 1
         transform = CGAffineTransformIdentity;
         break;
         
      case UIImageOrientationUpMirrored: //EXIF = 2
         transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
         transform = CGAffineTransformScale(transform, -1.0, 1.0);
         break;
         
      case UIImageOrientationDown: //EXIF = 3
         transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
         transform = CGAffineTransformRotate(transform, M_PI);
         break;
         
      case UIImageOrientationDownMirrored: //EXIF = 4
         transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
         transform = CGAffineTransformScale(transform, 1.0, -1.0);
         break;
         
      case UIImageOrientationLeftMirrored: //EXIF = 5
         boundHeight = bounds.size.height;
         bounds.size.height = bounds.size.width;
         bounds.size.width = boundHeight;
         transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
         transform = CGAffineTransformScale(transform, -1.0, 1.0);
         transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
         break;
         
      case UIImageOrientationLeft: //EXIF = 6
         boundHeight = bounds.size.height;
         bounds.size.height = bounds.size.width;
         bounds.size.width = boundHeight;
         transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
         transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
         break;
         
      case UIImageOrientationRightMirrored: //EXIF = 7
         boundHeight = bounds.size.height;
         bounds.size.height = bounds.size.width;
         bounds.size.width = boundHeight;
         transform = CGAffineTransformMakeScale(-1.0, 1.0);
         transform = CGAffineTransformRotate(transform, M_PI / 2.0);
         break;
         
      case UIImageOrientationRight: //EXIF = 8
         boundHeight = bounds.size.height;
         bounds.size.height = bounds.size.width;
         bounds.size.width = boundHeight;
         transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
         transform = CGAffineTransformRotate(transform, M_PI / 2.0);
         break;
         
      default:
         [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
         
   }
   
   //UIGraphicsBeginImageContext(bounds.size);
   UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   
   if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
      CGContextScaleCTM(context, -scaleRatio, scaleRatio);
      CGContextTranslateCTM(context, -height, 0);
   }
   else {
      CGContextScaleCTM(context, scaleRatio, -scaleRatio);
      CGContextTranslateCTM(context, 0, -height);
   }
   
   CGContextConcatCTM(context, transform);
   
   CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
   UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   
   return imageCopy;
}
- (void)cancelPopUpView:(UITapGestureRecognizer *)recog
{
   if (self.sharePopUpView.hidden == NO || maskView.hidden == NO||self.queryPopUpView) {
      self.sharePopUpView.hidden = YES;
      self.queryPopUpView.hidden = YES;
      maskView.hidden = YES;
      [self.view endEditing:YES];
   }
}
- (void)showQueryPopUpView
{
   self.queryPopUpView.hidden = NO;
   maskView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , self.view.frame.size.width, self.view.frame.size.height)];
   maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
   [self.view addSubview:maskView];
   [self.view bringSubviewToFront:self.queryPopUpView];
   self.queryPopUpTopView.layer.cornerRadius = self.queryPopUpTopView.bounds.size.width/2;
   self.queryPopUpTopView.layer.masksToBounds = YES;
   self.queryPopUpTopView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:1.0];
   
   self.queryPopUpView.layer.cornerRadius = 10;
   self.queryPopUpView.layer.masksToBounds = NO;
   self.confirmButton.layer.cornerRadius = 14;
   self.confirmButton.layer.masksToBounds = YES;
   self.confirmButton.backgroundColor = [UIColor colorWithHexString:@"a71645"];
   
}
- (void)popShareView
{
   
   self.sharePopUpView.hidden = NO;
   maskView = [[UIView alloc]initWithFrame:CGRectMake(0,0 , self.view.frame.size.width, self.view.frame.size.height)];
   maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
   [self.view addSubview:maskView];
   [self.view bringSubviewToFront:self.sharePopUpView];
   self.sharePopUpTopView.layer.cornerRadius = self.sharePopUpTopView.bounds.size.width/2;
   self.sharePopUpTopView.layer.masksToBounds = YES;
   self.sharePopUpTopView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:1.0];
   
   self.sharePopUpView.layer.cornerRadius = 10;
   self.sharePopUpView.layer.masksToBounds = NO;
   self.fbShareButtonView.layer.cornerRadius = 10;
   self.fbShareButtonView.layer.masksToBounds = YES;
   self.wbShareButtonView.layer.cornerRadius = 10;
   self.wbShareButtonView.layer.masksToBounds = YES;
   
   
   
   
}
- (void)resultPopUpView:(NSString*)returnedPoints
{
   /*self.shareResultPopUpView.hidden = NO;
    
    [self.view bringSubviewToFront:self.shareResultPopUpView];
    self.shareResultPopUpTopView.layer.cornerRadius = self.shareResultPopUpTopView.bounds.size.width/2;
    self.shareResultPopUpTopView.layer.masksToBounds = YES;
    self.shareResultPopUpTopView.backgroundColor = [UIColor colorWithHexString:@"a71645" alpha:1.0];
    self.shareResultPopUpView.layer.cornerRadius = 10;
    self.shareResultPopUpView.layer.masksToBounds = NO;
    self.resultDoneButton.layer.cornerRadius = 14;
    self.resultDoneButton.layer.masksToBounds = YES;
    self.resultDoneButton.backgroundColor = [UIColor colorWithHexString:@"a71645"];*/
   SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
   [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
   [alert setBodyTextFontFamily:@"Superclarendon" withSize:12.0f];
   NSString *pointString = [NSString stringWithFormat:NSLocalizedString(@"獲得分享點數%@點", nil),returnedPoints];
   [alert showCustom:[UIImage imageNamed:@"img_point"] color:[UIColor colorWithHexString:@"a71645"] title:@"" subTitle:pointString closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f]; // Custom
}

- (IBAction)confirmAction:(id)sender {
   self.queryPopUpView.hidden = YES;
   maskView.hidden = YES;
   if (self.contextTextView.text.length > 0 && self.contactTextField.text.length > 0)
   {
      [self.contextTextView resignFirstResponder];
      [[VintageApiService sharedInstance]sendMessageInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] wine_id:[self.selectedWineInfoDictionary objectForKey:@"id"] user_info:self.contactTextField.text message:self.contextTextView.text];
   }
   else
   {
      SCLAlertView *alert = [[SCLAlertView alloc] init];
      
      [alert setTitleFontFamily:@"Superclarendon" withSize:14.0f];
      
      [alert showWarning:self title:NSLocalizedString(@"聯絡方式或留言不可為空", nil) subTitle:@"" closeButtonTitle:NSLocalizedString(@"確定", nil) duration:0.0f];
   }
   
   
   
   
   
}
- (IBAction)queryAction:(id)sender {
   [self showQueryPopUpView];
}

- (IBAction)fbShareAction:(id)sender {
   
   FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
   content.contentTitle = [self.selectedWineInfoDictionary valueForKey:@"title_tw"];
   content.contentDescription = [self.selectedWineInfoDictionary valueForKey:@"title_tw"];
   //content.imageURL = [NSURL URLWithString:[self.selectedWineInfoDictionary valueForKey:@"pic_url"]];
   content.contentURL = [NSURL URLWithString:[self.selectedWineInfoDictionary valueForKey:@"pic_url"]];
   
   NSLog(@"fb sharecontent.contentTitle:%@",content.contentTitle);
   NSLog(@"fb imageURL:%@",content.imageURL);
   FBSDKShareDialog *shareDialog = [FBSDKShareDialog new];
   [shareDialog setDelegate:self];
   [shareDialog setMode:FBSDKShareDialogModeNative];
   //[shareDialog setMode:FBSDKShareDialogModeFeedWeb];
   [shareDialog setShareContent:content];
   [shareDialog setFromViewController:self];
   [shareDialog show];
   
}

- (void)sharer:	(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
   NSLog(@"didCompleteWithResults share result:%@",results);
   /*
   if ([results count]>0)
   {
      self.sharePopUpView.hidden = YES;
      [[VintageApiService sharedInstance]addPointsListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] wind_id:[self.selectedWineInfoDictionary valueForKey:@"id"]];
   }
   */
   self.sharePopUpView.hidden = YES;
   [[VintageApiService sharedInstance]addPointsListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] wind_id:[self.selectedWineInfoDictionary valueForKey:@"id"]];
   
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
   NSLog(@"FB: ERROR=%@\n",error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
   NSLog(@"FB: CANCELED SHARER");
}

- (IBAction)wbShareAction:(id)sender {
   AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
   
   WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
   authRequest.redirectURI = @"https://api.weibo.com/2/comments/create.json";
   authRequest.scope = @"all";
   
   WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
   request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                        @"Other_Info_1": [NSNumber numberWithInt:123],
                        @"Other_Info_2": @[@"obj1", @"obj2"],
                        @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
   
   [WeiboSDK sendRequest:request];
   //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFectchWeiboInfoNotification:) name:FetchingWeiboInfoNotification object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onFectchWeiboInfoNotification:) name:FetchingWeiboInfoNotification object:nil];
   
}
- (void)onFectchWeiboInfoNotification:(NSNotification*)notify
{
   NSLog(@"onFectchWeiboInfoNotification:%@",notify.object);
   
   self.sharePopUpView.hidden = YES;
   [[VintageApiService sharedInstance]addPointsListInfo:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] token:[[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"] wind_id:[self.selectedWineInfoDictionary valueForKey:@"id"]];
   
}
- (WBMessageObject *)messageToShare
{
   WBMessageObject *message = [WBMessageObject message];
   message.text = [self.selectedWineInfoDictionary valueForKey:@"title_tw"];
   WBImageObject *image = [WBImageObject object];
   NSURL *url = [NSURL URLWithString:[self.selectedWineInfoDictionary valueForKey:@"pic_url"]];
   NSData *imageData = [NSData dataWithContentsOfURL:url];
   UIImage* img = [UIImage imageWithData:imageData];
   
   CGFloat compression = 0.9f;
   NSData *compressedImage = UIImageJPEGRepresentation(img, compression);
   int maxFileSize = 32*1024;
   NSLog(@"[compressedImage length]:%lu",(unsigned long)[compressedImage length]);
   
   while ([compressedImage length] > maxFileSize)
   {
      compression -= 0.1;
      compressedImage = UIImageJPEGRepresentation(img, compression);
      
   }
   
   image.imageData = [NSData dataWithData:compressedImage];
   message.imageObject = image;
   return message;
}
- (void) keyboardWillShow:(NSNotification*) note
{
   NSLog(@"keyboardWillShow");
   
   NSDictionary* info = [note userInfo];
   CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   
   NSValue* keyboardFrameBegin = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
   CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
   CGFloat keyboardHeight = keyboardFrame.size.height;
   
   CGRect screenRect = [[UIScreen mainScreen] bounds];
   CGFloat screenHeight = screenRect.size.height;
   
   NSLog(@"screenHeight:%f keyboardWillShow:%f self.controlView.frame.size.height:%f newHeight:%f",screenHeight, keyboardHeight, self.view.frame.size.height, screenHeight - keyboardHeight - self.view.frame.size.height);
   
   [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
   if ([self.contactTextField isFirstResponder]) {
      [UIView animateWithDuration:0.25
                            delay:0
                          options:UIViewAnimationOptionBeginFromCurrentState
                       animations:(void (^)(void)) ^{
                          self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                       screenHeight - kbSize.height - self.view.frame.size.height + self.contactTextField.frame.size.height,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height);
                       } completion:^(BOOL finished){
                       }];
   }
   else
   {
      [UIView animateWithDuration:0.25
                            delay:0
                          options:UIViewAnimationOptionBeginFromCurrentState
                       animations:(void (^)(void)) ^{
                          self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                       screenHeight - kbSize.height - self.view.frame.size.height,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height);
                       } completion:^(BOOL finished){
                       }];
   }
   
   
}

- (void) keyboardWillHide:(NSNotification*) note
{
   NSLog(@"keyboardWillHide");
   
   CGRect screenRect = [[UIScreen mainScreen] bounds];
   CGFloat screenHeight = screenRect.size.height;
   
   
   NSLog(@"screenHeight:%f newHeight:%f", screenHeight, screenHeight-self.view.frame.size.height);
   [UIView animateWithDuration:0.25
                         delay:0
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:(void (^)(void)) ^{
                       
                       self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                    screenHeight-self.view.frame.size.height,
                                                    self.view.frame.size.width,
                                                    self.view.frame.size.height);
                       
                    }
                    completion:^(BOOL finished){
                       
                    }];
}
- (BOOL)textFieldShouldReturn:(id)sender {
   
   [sender resignFirstResponder];
   
   return NO;
}
@end
