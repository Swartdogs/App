//
//  SDReachability.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "SDReachability.h"

@implementation SDReachability

- (NetworkStatus) currentReachabilityStatus {
    NSAssert(reachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
    NetworkStatus retVal = NotReachable;
    SCNetworkReachabilityFlags flags;
    
    if(SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
        if(localWifi) {
            retVal = [self localWiFiStatusForFlags: flags];
        } else {
            retVal = [self networkStatusForFlags: flags];
        }
    }
    
    return retVal;
}

- (void) dealloc {
    [self stopNotifier];
    if(reachabilityRef != NULL) {
        CFRelease(reachabilityRef);
    }
}

- (NetworkStatus) localWiFiStatusForFlags:(SCNetworkReachabilityFlags)flags {
    BOOL retVal = NotReachable;
    
    if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect)) {
        retVal = ReachableViaWiFi;
    }
    return retVal;
}

- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
		return NotReachable;
	}
    
	BOOL retVal = NotReachable;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
		retVal = ReachableViaWiFi;
	}
	
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
            retVal = ReachableViaWiFi;
        }
    }
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
		retVal = ReachableViaWWAN;
	}
	return retVal;
}

static void reachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
	NSCAssert([(NSObject*) CFBridgingRelease(info) isKindOfClass:[SDReachability class]], @"info was wrong class in ReachabilityCallback");
    
    
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someon uses the Reachablity object in a different thread.
	
	SDReachability* noteObject = (__bridge SDReachability*) info;
    
	// Post a notification to notify the client that the network reachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
}

- (BOOL) startNotifier {
    BOOL retVal = NO;
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    if(SCNetworkReachabilitySetCallback(reachabilityRef, reachabilityCallback, &context)) {
        if(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
            retVal = YES;
            return retVal;
        }
    }
    return retVal;
}

- (void) stopNotifier {
    if(reachabilityRef != NULL) {
        SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

+ (SDReachability*) reachabilityForInternetConnection {
    struct sockaddr_in zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*) &zeroAddress);
    
    SDReachability* retVal = NULL;
    
    if(reachability != NULL) {
        retVal = [[self alloc] init];
        
        if(retVal != NULL) {
            retVal->reachabilityRef = reachability;
            retVal->localWifi = NO;
        }
    }
    return retVal;
}

+ (SDReachability*) reachabilityForLocalWiFi {
    struct sockaddr_in localWifiAddress;
    
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&localWifiAddress);
    
    SDReachability* retVal = NULL;
    
    if(reachability != NULL) {
        retVal = [[self alloc] init];
        
        if(retVal != NULL) {
            retVal->reachabilityRef = reachability;
            retVal->localWifi = YES;
        }
    }
    
    return retVal;
}

@end