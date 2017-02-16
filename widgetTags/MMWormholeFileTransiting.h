//
//  MMWormholeFileTransiting.h
//  WidgetTopTags
//
//  Created by Edward Snowden on 03.02.17.
//  Copyright © 2017 Anna Zelinskaya. All rights reserved.
//

#import "MMWormholeTransiting.h"

NS_ASSUME_NONNULL_BEGIN


@interface MMWormholeFileTransiting : NSObject <MMWormholeTransiting>


- (instancetype)initWithApplicationGroupIdentifier:(nullable NSString *)identifier
                                 optionalDirectory:(nullable NSString *)directory NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) NSFileManager *fileManager;

@end

NS_ASSUME_NONNULL_END
