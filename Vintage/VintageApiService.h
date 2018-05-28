//
//  VintageApiService.h
//  Vintage
//
//  Created by Will Tang on 5/8/15.
//  Copyright (c) 2015 Moska Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONKit.h>

extern NSString *ThirdPartyRegisterFinishedNotification;
extern NSString *EmailRegisterFinishedNotification;
extern NSString *LoginFromEmailFinishedNotification;
extern NSString *LoginFromThirdPartyFinishedNotification;
extern NSString *FetchingHomeBannerNotification;
extern NSString *FetchingSearchInfoNotification;
extern NSString *FetchingSingleEventNotification;
extern NSString *FetchingWineListNotification;
extern NSString *FetchingNewItemListNotification;
extern NSString *FetchingExpertListNotification;
extern NSString *FetchingHotItemListNotification;
extern NSString *FetchingSeasonItemListNotification;
extern NSString *FetchingGiftItemListNotification;
extern NSString *FetchingQuizListNotification;
extern NSString *FetchingWaiterListNotification;
extern NSString *FetchingCollectionListNotification;
extern NSString *FetchingWaiterResultListNotification;
extern NSString *SetCollectionNotification;
extern NSString *FetchingPersonalInfoNotification;
extern NSString *FetchingSlotMachineInfoNotification;
extern NSString *CancelCollectionNotification;
extern NSString *FetchNearbyShopListNotification;
extern NSString *FetchingGiftListNotification;
extern NSString *updatePointsListNotification;
extern NSString *addPointsListNotification;
extern NSString *sendMessageNotification;
extern NSString *SendQuizAnswerNotification;
extern NSString *FetchingCollectionInfoNotification;
extern NSString *FetchingCityInfoNotification;
extern NSString *RetailRedeemNotification;
extern NSString *OnlineRedeemNotification;
extern NSString *SendSlotRequestNotification;
extern NSString *ResetPasswordNotification;
extern NSString *PushMessageNotification;
@interface VintageApiService : NSObject
@property NSString* lastTappedIndex;
+ (id) sharedInstance;
- (void)registerFromEmail:(NSString*)email password:(NSString*)password pwd_confirm:(NSString*)pwd_confirm name:(NSString*)name;
- (void)loginFromEmail:(NSString*)email password:(NSString*)password;
- (void)loginFromThirdParty:(NSString*)facebook_id weibo_id:(NSString*)weibo_id email:(NSString*)email name:(NSString*)name;

- (void)fetchHomeBanner:(NSString*)user_id token:(NSString*)access_token device_token:(NSString*)device_token device_type:(NSString*)device_type device_language:(NSString*)device_language;
- (void)fetchSearchInfo:(NSString*)user_id token:(NSString*)access_token keyword:(NSString*)keyword;
- (void)fetchWineListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID search:(NSString*)search;
- (void)fetchSingleEventInfo;
- (void)fetchNewItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID;
- (void)fetchExpertListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID;
- (void)fetchHotItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID;
- (void)fetchSeasonItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID;
- (void)fetchGiftItemListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID;
- (void)fetchWaiterResultListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID option_ids:(NSString*)option_ids;
- (void)fetchQuizListInfo:(NSString*)user_id token:(NSString*)access_token date:(NSString*)today;
- (void)fetchWaiterListInfo:(NSString*)combo_num;
- (void)fetchCollectionListInfo:(NSString*)user_id token:(NSString*)access_token order_by:(NSString*)order_by order:(NSString*)order limit:(NSString*)limit offset:(NSString*)offset country_id:(NSString*)countryID wine_type_id:(NSString*)wineTypeID;
- (void)setCollectionListInfo:(NSString*)user_id token:(NSString*)access_token wine_id:(NSString*)wine_id;
- (void)cancelCollectionListInfo:(NSString*)user_id token:(NSString*)access_token wine_ids:(NSString*)wine_ids;
- (void)fetchPersonlInfo:(NSString*)user_id token:(NSString*)access_token;
- (void)fetchCollectionInfo:(NSString*)user_id token:(NSString*)access_token keyword:(NSString*)keyword;
- (void)fetchNearbyShopListInfo:(NSString*)cityName;
- (void)fetchGiftListInfo:(NSString*)user_id token:(NSString*)access_token;
- (void)fetchSlotMachineListInfo;
- (void)addPointsListInfo:(NSString*)user_id token:(NSString*)access_token wind_id:(NSString*)wind_id;
- (void)updatePointsListInfo:(NSString*)user_id token:(NSString*)access_token activity_id:(NSString*)activity_id;
- (void)sendMessageInfo:(NSString*)user_id token:(NSString*)access_token wine_id:(NSString*)wine_id user_info:(NSString*)user_info message:(NSString*)message;
- (void)sendQuizAnswerInfo:(NSString*)user_id token:(NSString*)access_token game_id:(NSString*)game_id;
- (void)fetchCityListInfo;
- (void)retailRedeem:(NSString*)user_id token:(NSString*)access_token my_gift_id:(NSString*)my_gift_id pwd:(NSString*)pwd;
- (void)onlineRedeem:(NSString*)user_id token:(NSString*)access_token my_gift_id:(NSString*)my_gift_id name:(NSString*)name phone:(NSString*)phone address:(NSString*)address;
- (void)sendSlotMachineRequest:(NSString*)user_id token:(NSString*)access_token;
- (void)resetPasswordRequest:(NSString*)email;
- (void)pushMessageNotification:(NSString*)push_message_id device_token:(NSString*)device_token device_type:(NSString*)device_type device_language:(NSString*)device_language;
@end
