//
//  VintageApiService.m
//  Vintage
//
//  Created by Will Tang on 5/8/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import "VintageApiService.h"
#import "AFHTTPRequestOperationManager.h"
#import "SCLAlertView.h"

NSString *ThirdPartyRegisterFinishedNotification = @"ThirdPartyRegisterFinishedNotification";
NSString *EmailRegisterFinishedNotification = @"EmailRegisterFinishedNotification";
NSString *LoginFromEmailFinishedNotification = @"LoginFromEmailFinishedNotification";
NSString *LoginFromThirdPartyFinishedNotification = @"LoginFromThirdPartyFinishedNotification";
NSString *FetchingHomeBannerNotification = @"FetchingHomeBannerNotification";
NSString *FetchingSearchInfoNotification = @"FetchingSearchInfoNotification";
NSString *FetchingSingleEventNotification = @"FetchingSingleEventNotification";
NSString *FetchingWineListNotification = @"FetchingWineListNotification";
NSString *FetchingNewItemListNotification = @"FetchingNewItemListNotification";
NSString *FetchingExpertListNotification = @"FetchingExpertListNotification";
NSString *FetchingHotItemListNotification = @"FetchingHotItemListNotification";
NSString *FetchingSeasonItemListNotification = @"FetchingSeasonItemListNotification";
NSString *FetchingGiftItemListNotification = @"FetchingGiftItemListNotification";
NSString *FetchingWaiterResultListNotification = @"FetchingWaiterResultListNotification";
NSString *FetchingQuizListNotification = @"FetchingQuizListNotification";
NSString *FetchingWaiterListNotification = @"FetchingWaiterListNotification";
NSString *FetchingCollectionListNotification = @"FetchingCollectionListNotification";
NSString *SetCollectionNotification = @"SetCollectionNotification";
NSString *CancelCollectionNotification = @"CancelCollectionNotification";
NSString *FetchingCollectionInfoNotification = @"FetchingCollectionInfoNotification";
NSString *FetchNearbyShopListNotification = @"FetchNearbyShopListNotification";
NSString *FetchingGiftListNotification = @"FetchingGiftListNotification";
NSString *FetchingPersonalInfoNotification = @"FetchingPersonalInfoNotification";
NSString *FetchingSlotMachineInfoNotification = @"FetchingSlotMachineInfoNotification";
NSString *updatePointsListNotification = @"updatePointsListNotification";
NSString *addPointsListNotification = @"addPointsListNotification";
NSString *sendMessageNotification = @"sendMessageNotification";
NSString *SendQuizAnswerNotification = @"SendQuizAnswerNotification";
NSString *FetchingCityInfoNotification = @"FetchingCityInfoNotification";
NSString *RetailRedeemNotification = @"RetailRedeemNotification";
NSString *OnlineRedeemNotification = @"OnlineRedeemNotification";
NSString *SendSlotRequestNotification = @"SendSlotRequestNotification";
NSString *ResetPasswordNotification = @"ResetPasswordNotification";
NSString *PushMessageNotification = @"PushMessageNotification";
@implementation VintageApiService

+ (id) sharedInstance
{
    static VintageApiService* sharedMyInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] initService];
    });
    return sharedMyInstance;
}
- (id) initService
{
    self = [super init];
    if (self)
    {
        
        
    }
    return self;
}
// Login & Register
- (void) registerFromEmail:(NSString*)email password:(NSString*)password pwd_confirm:(NSString*)pwd_confirm name:(NSString*)name
{
    NSLog(@"onRegisterFromEmailNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"email": email,
                                 @"pwd": password,
                                 @"pwd_confirm":pwd_confirm,
                                 @"name":name
                                 };
    NSLog(@"param:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/user/register" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 8){
            [[NSNotificationCenter defaultCenter] postNotificationName:EmailRegisterFinishedNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful register");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
        
    }];
}
- (void)loginFromEmail:(NSString*)email password:(NSString*)password
{
    NSLog(@"onLoginFromEmailFinishedNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"email": email,
                                 @"pwd": password,
                                 };
    NSLog(@"param:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/user/login" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 1||status == 2||status == 3){
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginFromEmailFinishedNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)loginFromThirdParty:(NSString*)facebook_id weibo_id:(NSString*)weibo_id email:(NSString*)email name:(NSString*)name
{
    NSLog(@"onLoginFromThirdPartyFinishedNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"facebook_id":facebook_id,
                                 @"weibo_id":weibo_id,
                                 @"email": email,
                                 @"name": name
                                 };
    NSLog(@"param:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/user/third_party_login_and_register" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 1){
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginFromThirdPartyFinishedNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchHomeBanner:(NSString*)user_id token:(NSString*)access_token device_token:(NSString*)device_token device_type:(NSString*)device_type device_language:(NSString*)device_language
{
    NSLog(@"onFetchHomeBanner");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"device_token":device_token,
                                 @"device_type":device_type,
                                 @"device_language":device_language
                                 };
    NSLog(@"param:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/banner" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSString* status = [jsonDict objectForKey:@"ERR_CODE"] ;
        NSLog(@"banner status:%@",status);
        if (status){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingHomeBannerNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FetchingHomeBannerNotification object:error];
        
    }];

}
- (void)fetchSearchInfo:(NSString*)user_id token:(NSString*)access_token keyword:(NSString*)keyword
{
    NSLog(@"onSearchInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"keyword":keyword
                                 };
    NSLog(@"param:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/search" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 13){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingHomeBannerNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}

- (void)fetchSingleEventInfo
{
    NSLog(@"onFetchingSingleEventInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://app.tfhow-wine.com/index.php/activity/all" parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 22){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingSingleEventNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}

- (void)fetchWineListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID search:(NSString*)search
{
    NSLog(@"onFetchingWineListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"adding parameters");
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_ids":countryID,
                                 @"wine_type_ids":wineTypeID,
                                 @"keyword":search
                                 };
    NSLog(@"Parameters:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/search" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 14){
            NSLog(@"jsonDict");
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingWineListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchNewItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID
{
    NSLog(@"onFetchingNewItemListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_ids":countryID,
                                 @"wine_type_ids":wineTypeID
                                 };
    NSLog(@"Parameters:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/new_items" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 14){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingNewItemListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchExpertListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID
{
    NSLog(@"onFetchingExpertItemListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_ids":countryID,
                                 @"wine_type_ids":wineTypeID
                                 };
    NSLog(@"Parameters:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/recommended_items" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 14){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingExpertListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchHotItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID
{
    NSLog(@"onFetchingHotItemListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_ids":countryID,
                                 @"wine_type_ids":wineTypeID
                                 };
    NSLog(@"Parameters:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/hot_items" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 14){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingHotItemListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchSeasonItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID
{
    NSLog(@"onFetchingSeasonItemListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_ids":countryID,
                                 @"wine_type_ids":wineTypeID
                                 };
    NSLog(@"Parameters:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/in_season_items" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 14){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingSeasonItemListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchGiftItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID
{
    NSLog(@"onFetchingSeasonItemListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_ids":countryID,
                                 @"wine_type_ids":wineTypeID
                                 };
    NSLog(@"Parameters:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/gift_items" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 14){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingGiftItemListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchQuizListInfo:(NSString*)user_id token:(NSString*)access_token date:(NSString*)today
{
    NSLog(@"onFetchingQuizListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"today":today
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/game/all" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 28 || status == 29){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingQuizListNotification object:jsonDict];
        }
        
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchWaiterListInfo:(NSString*)combo_num
{
    NSLog(@"onFetchingWaiterListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"combo_num":combo_num,
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/question/all_v2" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 26){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingWaiterListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchCollectionListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID
{
    NSLog(@"onFetchingCollectionListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_ids":countryID,
                                 @"wine_type_ids":wineTypeID
                                 
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/wine/my_likes" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 25){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingCollectionListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchWaiterResultListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID option_ids:(NSString*)option_ids
{
    NSLog(@"onFetchWaiterResultListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"order_by":order_by,
                                 @"order":order,
                                 @"limit":limit,
                                 @"offset":offset,
                                 @"country_id":countryID,
                                 @"wine_type_id":wineTypeID,
                                 @"option_ids":option_ids
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/question/answer" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 27){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingWaiterResultListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];

}
- (void)setCollectionListInfo:(NSString*)user_id token:(NSString*)access_token wine_id:(NSString*)wine_id
{
    NSLog(@"onSetCollectionListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"wine_id":wine_id
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/wine/like" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 15){
            [[NSNotificationCenter defaultCenter] postNotificationName:SetCollectionNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)cancelCollectionListInfo:(NSString*)user_id token:(NSString*)access_token wine_ids:(NSString*)wine_ids
{
    NSLog(@"onCancelCollectionListInfoNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"wine_ids":wine_ids
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/wine/dislike" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 16){
            [[NSNotificationCenter defaultCenter] postNotificationName:CancelCollectionNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}

- (void)fetchNearbyShopListInfo:(NSString *)cityName
{
    NSLog(@"onfetchNearbyShopListInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"county_id":cityName
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/store/all" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 20){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchNearbyShopListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchGiftListInfo:(NSString*)user_id token:(NSString*)access_token
{
    NSLog(@"onfetchGiftListInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/my_gift/all" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 34){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingGiftListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)addPointsListInfo:(NSString*)user_id token:(NSString*)access_token wind_id:(NSString*)wind_id
{
    NSLog(@"onUpdatingPointListInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"wine_id":wind_id
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/wine/share" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 18 || status == 19){
            [[NSNotificationCenter defaultCenter] postNotificationName:updatePointsListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)updatePointsListInfo:(NSString*)user_id token:(NSString*)access_token activity_id:(NSString*)activity_id
{
    NSLog(@"onUpdatingPointListInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"activity_id":activity_id
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/activity/activity_share" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 23 || status == 24){
            [[NSNotificationCenter defaultCenter] postNotificationName:updatePointsListNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)sendMessageInfo:(NSString*)user_id token:(NSString*)access_token wine_id:(NSString*)wine_id user_info:(NSString*)user_info message:(NSString*)message
{
    NSLog(@"onSendingMessageInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"wine_id":wine_id,
                                 @"user_info":user_info,
                                 @"message":message
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/wine/ask_price" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 17){
            [[NSNotificationCenter defaultCenter] postNotificationName:sendMessageNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchPersonlInfo:(NSString*)user_id token:(NSString*)access_token
{
    NSLog(@"onFetchPersonlInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/user/info" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 11){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingPersonalInfoNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchSlotMachineListInfo
{
    NSLog(@"onFetchSlotMachineInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://app.tfhow-wine.com/index.php/slot/all" parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 32){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingSlotMachineInfoNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];

}
- (void)sendQuizAnswerInfo:(NSString*)user_id token:(NSString*)access_token game_id:(NSString*)game_id
{
    NSLog(@"onsendQuizAnswerInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //先判斷是否登入過
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"game_id":game_id
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/game/answer" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 30 || status ==31){
            [[NSNotificationCenter defaultCenter] postNotificationName:SendQuizAnswerNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchCollectionInfo:(NSString*)user_id token:(NSString*)access_token keyword:(NSString*)keyword
{
    NSLog(@"onFetchingCollectionInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //先判斷是否登入過
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"keyword":keyword
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/homepage/search" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 14){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingCollectionInfoNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)fetchCityListInfo
{
    NSLog(@"onFetchingCityInfo");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://app.tfhow-wine.com/index.php/store/all_counties_and_districts" parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 21){
            [[NSNotificationCenter defaultCenter] postNotificationName:FetchingCityInfoNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)retailRedeem:(NSString*)user_id token:(NSString*)access_token my_gift_id:(NSString*)my_gift_id pwd:(NSString*)pwd
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"my_gift_id":my_gift_id,
                                 @"pwd":pwd
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/my_gift/exchange" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 36 || status == 39){
            [[NSNotificationCenter defaultCenter] postNotificationName:RetailRedeemNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)onlineRedeem:(NSString*)user_id token:(NSString*)access_token my_gift_id:(NSString*)my_gift_id name:(NSString*)name phone:(NSString*)phone address:(NSString*)address
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token,
                                 @"my_gift_id":my_gift_id,
                                 @"name":name,
                                 @"phone":phone,
                                 @"address":address
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/my_gift/exchange" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 35 || status == 39){
            [[NSNotificationCenter defaultCenter] postNotificationName:OnlineRedeemNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)sendSlotMachineRequest:(NSString*)user_id token:(NSString*)access_token
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"user_id":user_id,
                                 @"access_token":access_token
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/slot/result" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 33 || status == 332){
            [[NSNotificationCenter defaultCenter] postNotificationName:SendSlotRequestNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
- (void)resetPasswordRequest:(NSString*)email
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"email":email
                                 };
    [manager POST:@"http://app.tfhow-wine.com/index.php/user/forget_password" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"responseStr:%@", responseStr);
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"] integerValue];
        NSLog(@"Status = %ld",(long)status);
        
        if (status == 2 || status == 5|| status == 12){
            [[NSNotificationCenter defaultCenter] postNotificationName:ResetPasswordNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}

- (void)pushMessageNotification:(NSString*)push_message_id device_token:(NSString*)device_token device_type:(NSString*)device_type device_language:(NSString*)device_language
{
    NSLog(@"onFetchPushMessageNotification");
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"push_message_id":push_message_id,
                                 @"device_token":device_token,
                                 @"device_type":device_type,
                                 @"device_language":device_language
                                 };
    NSLog(@"param:%@",parameters);
    [manager POST:@"http://app.tfhow-wine.com/index.php/notification_record/create" parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSString* responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [responseStr objectFromJSONStringWithParseOptions:JKParseOptionPermitTextAfterValidJSON];
        NSInteger status = [[jsonDict objectForKey:@"ERR_CODE"]integerValue] ;
        NSLog(@"banner status:%ld",(long)status);
        if (status == 40){
            [[NSNotificationCenter defaultCenter] postNotificationName:PushMessageNotification object:jsonDict];
        }
        else{
            NSLog(@"Unsuccessful login");
        }
    }     failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Failed error = %@",error);
        
    }];
}
@end
