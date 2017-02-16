//
//  MMWormholeFileTransiting.m
//  WidgetTopTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMWormholeFileTransiting.h"

@interface MMWormholeFileTransiting ()

@property (nonatomic, copy) NSString *applicationGroupIdentifier;
@property (nonatomic, copy) NSString *directory;
@property (nonatomic, strong, readwrite) NSFileManager *fileManager;

@end

@implementation MMWormholeFileTransiting

- (instancetype)init {
    return [self initWithApplicationGroupIdentifier:@"dev.assertion.nonDesignatedInitializer"
                                  optionalDirectory:nil];
}

- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory {
    if ((self = [super init])) {
        _applicationGroupIdentifier = [identifier copy];
        _directory = [directory copy];
        _fileManager = [[NSFileManager alloc] init];
    }
    
    return self;
}

#pragma mark - Public Protocol Methods

- (BOOL)writeMessageObject:(id<NSCoding>)messageObject forIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        return NO;
    }
    return YES;
}
@end
