//
//  SDFileUpload.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDFileUpload : NSObject <NSStreamDelegate> {
    NSInputStream*  streamFromFile;
    NSOutputStream* streamToHost;
    NSTimer*        timeoutTimer;
    
    uint8_t         writeBuffer[2048];
    size_t          writeBufferOffset;
    size_t          writeBufferLimit;
}

- (void) startUpload:(NSString*)filePath toFtpServer:(NSString*)serverName userName:(NSString*)user userPassword:(NSString*)password;
- (void) stopUpload;

@end
