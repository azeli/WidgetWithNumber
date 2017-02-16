//
//  MMWormhole.m
//  WidgetTopTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "MMWormhole.h"

#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#include <CoreFoundation/CoreFoundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MMWormholeNotificationName = @"MMWormholeNotificationName";

void wormholeNotificationCallback(CFNotificationCenterRef center,
                                  void * observer,
                                  CFStringRef name,
                                  void const * object,
                                  CFDictionaryRef userInfo);

@interface MMWormhole ()

@property (nonatomic, strong) NSMutableDictionary *listenerBlocks;

@end

@implementation MMWormhole

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

- (id)init {
    return nil;
}

#pragma clang diagnostic pop

- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory {
    if ((self = [super init])) {
        
        if (NO == [[NSFileManager defaultManager] respondsToSelector:@selector(containerURLForSecurityApplicationGroupIdentifier:)]) {
            return nil;
        }
        
        self.wormholeMessenger = [[MMWormholeFileTransiting alloc] initWithApplicationGroupIdentifier:[identifier copy]
                                                                                    optionalDirectory:[directory copy]];

        _listenerBlocks = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMessageNotification:)
                                                     name:MMWormholeNotificationName
                                                   object:self];
    }
    
    return self;
}

#pragma mark - Private Notification Methods

- (void)sendNotificationForMessageWithIdentifier:(nullable NSString *)identifier {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFDictionaryRef const userInfo = NULL;
    BOOL const deliverImmediately = YES;
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterPostNotification(center, str, NULL, userInfo, deliverImmediately);
}

- (void)registerForNotificationsWithIdentifier:(nullable NSString *)identifier {
    [self unregisterForNotificationsWithIdentifier:identifier];
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterAddObserver(center,
                                    (__bridge const void *)(self),
                                    wormholeNotificationCallback,
                                    str,
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (void)unregisterForNotificationsWithIdentifier:(nullable NSString *)identifier {
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)identifier;
    CFNotificationCenterRemoveObserver(center,
                                       (__bridge const void *)(self),
                                       str,
                                       NULL);
}

void wormholeNotificationCallback(CFNotificationCenterRef center,
                               void * observer,
                               CFStringRef name,
                               void const * object,
                               CFDictionaryRef userInfo) {
    NSString *identifier = (__bridge NSString *)name;
    NSObject *sender = (__bridge NSObject *)(observer);
    [[NSNotificationCenter defaultCenter] postNotificationName:MMWormholeNotificationName
                                                        object:sender
                                                      userInfo:@{@"identifier" : identifier}];
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *identifier = [userInfo valueForKey:@"identifier"];
    
    if (identifier != nil) {
        id messageObject = [self.wormholeMessenger messageObjectForIdentifier:identifier];

        [self notifyListenerForMessageWithIdentifier:identifier message:messageObject];
    }
}

- (id)listenerBlockForIdentifier:(NSString *)identifier {
    return [self.listenerBlocks valueForKey:identifier];
}

- (void)notifyListenerForMessageWithIdentifier:(nullable NSString *)identifier message:(nullable id<NSCoding>)message {
    typedef void (^MessageListenerBlock)(id messageObject);

    MessageListenerBlock listenerBlock = [self listenerBlockForIdentifier:identifier];
    
    if (listenerBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            listenerBlock(message);
        });
    }
}


#pragma mark - Public Interface Methods

- (void)passMessageObject:(nullable id <NSCoding>)messageObject identifier:(nullable NSString *)identifier {
    if ([self.wormholeMessenger writeMessageObject:messageObject forIdentifier:identifier]) {
        [self sendNotificationForMessageWithIdentifier:identifier];
    }
}


- (nullable id)messageWithIdentifier:(nullable NSString *)identifier {
    id messageObject = [self.wormholeMessenger messageObjectForIdentifier:identifier];
    
    return messageObject;
}

- (void)listenForMessageWithIdentifier:(nullable NSString *)identifier
                              listener:(nullable void (^)(__nullable id messageObject))listener {
    if (identifier != nil) {
        [self.listenerBlocks setValue:listener forKey:identifier];
        [self registerForNotificationsWithIdentifier:identifier];
    }
}

- (void)stopListeningForMessageWithIdentifier:(nullable NSString *)identifier {
    if (identifier != nil) {
        [self.listenerBlocks setValue:nil forKey:identifier];
        [self unregisterForNotificationsWithIdentifier:identifier];
    }
}

@end

NS_ASSUME_NONNULL_END
