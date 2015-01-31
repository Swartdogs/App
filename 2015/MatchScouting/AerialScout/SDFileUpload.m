//
//  SDFileUpload.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDFileUpload.h"

@interface SDFileUpload()
    - (void)    isbusy:(BOOL)state;
    - (void)    sendMatchFile;
    - (void)    statusUpdate:(NSString*)message;
    - (NSURL*)  urlForString:(NSString*)str;

@end

@implementation SDFileUpload

- (id) init {
    self = [super init];
    return self;
}

- (void) isbusy:(BOOL)state {
    NSString* newState;
    if(state) {
        newState = @"YES";
    } else {
        newState = @"NO";
    }
    
    NSDictionary* info = [NSDictionary dictionaryWithObject:newState forKey:@"Info"];
    NSNotification* note = [NSNotification notificationWithName:@"Busy"
                                                         object:self
                                                       userInfo:info];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void) sendMatchFile {
    NSInteger byteCount;
    
    // If No data in buffer, get more from File
    
    if(writeBufferOffset == writeBufferLimit) {
        byteCount = [streamFromFile read:writeBuffer maxLength:2048];
        
        if(byteCount == -1) {
            [self statusUpdate:@"File Read Error"];
            [self stopUpload];
        } else if(byteCount == 0) {
            [self statusUpdate:@"Upload Completed"];
            [self stopUpload];
        } else {
            writeBufferOffset = 0;
            writeBufferLimit  = byteCount;
        }
    }
    
    // If data in buffer, send to Host
    
    if(writeBufferOffset != writeBufferLimit) {
        byteCount = [streamToHost write:&writeBuffer[writeBufferOffset] maxLength:writeBufferLimit-writeBufferOffset];
        
        if(byteCount == -1) {
            [self statusUpdate:@"Network Write Error"];
            [self stopUpload];
        } else {
            writeBufferOffset += byteCount;
        }
    }
}

- (void) startUpload:(NSString *)filePath toFtpServer:(NSString *)serverName userName:(NSString *)user userPassword:(NSString *)password {
    [self statusUpdate:@"Open Connection..."];
    [self isbusy:YES];
    
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                    target:self
                                                  selector:@selector(timeoutExpired:)
                                                  userInfo:nil
                                                   repeats:NO];
    
    // Open input stream From Match CSV File
    
    streamFromFile = [NSInputStream inputStreamWithFileAtPath:filePath];
    [streamFromFile open];
    
    NSURL* url = [self urlForString:serverName];
    
    if(url == nil) {
        [self statusUpdate:@"Invalid URL"];
        [self stopUpload];
        return;
    }
    
    url = CFBridgingRelease(CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef)[filePath lastPathComponent], false));
    
    streamToHost = CFBridgingRelease(CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url));
    
    [streamToHost setProperty:user forKey:(id) kCFStreamPropertyFTPUserName];
    [streamToHost setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
    
    // Open Output Stream to Host Computer
    
    [streamToHost setDelegate:self];
    [streamToHost scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [streamToHost open];
}

- (void) statusUpdate:(NSString *)message {
    NSDictionary* info = [NSDictionary dictionaryWithObject:message forKey:@"Info"];
    NSNotification* note = [NSNotification notificationWithName:@"Status"
                                                         object:self
                                                       userInfo:info];
    
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void) stopUpload {
    [timeoutTimer invalidate];
    [self isbusy:NO];
    
    if(streamToHost != nil) {
        streamToHost.delegate = nil;
        [streamToHost removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [streamToHost close];
        streamToHost = nil;
    }
    
    if(streamFromFile != nil) {
        [streamFromFile close];
        streamFromFile = nil;
    }
    
    timeoutTimer = nil;
    writeBufferOffset = 0;
    writeBufferLimit  = 0;
}

- (void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self statusUpdate:@"Connection Opened"];
        } break;
            
        case NSStreamEventHasBytesAvailable: {
        } break;
            
        case NSStreamEventHasSpaceAvailable: {
            [self statusUpdate:@"Connected"];
            [self sendMatchFile];
        } break;
            
        case NSStreamEventErrorOccurred: {
            [self statusUpdate:@"Connection Open Error"];
            [self stopUpload];
        } break;
            
        case NSStreamEventEndEncountered: {
        } break;
            
        default:
            break;
    }
}

- (void) timeoutExpired:(NSTimer*)theTimer {
    [self statusUpdate:@"Timeout"];
    [self stopUpload];
}

- (NSURL*) urlForString:(NSString *)str {
    NSURL*    result;
    NSString* trimmedStr;
    NSRange   schemeMarkerRange;
    NSString* scheme;
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if((trimmedStr != nil) && ([trimmedStr length] != 0)) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if(schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            
            if(([scheme compare:@"ftp" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
                result = [NSURL URLWithString:trimmedStr];
            }
        }
    }
    
    return result;
}

@end
