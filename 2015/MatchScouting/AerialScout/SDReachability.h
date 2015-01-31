//
//  SDReachability.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface SDReachability : NSObject {
    BOOL localWifi;
    SCNetworkReachabilityRef reachabilityRef;
}

+ (SDReachability*) reachabilityForLocalWiFi;
+ (SDReachability*) reachabilityForInternetConnection;

- (BOOL) startNotifier;
- (void) stopNotifier;

- (NetworkStatus) currentReachabilityStatus;

@end
