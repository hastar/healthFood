//
//  NSString+fileCaches.h
//  文件缓存Demo
//
//  Created by lanou on 15/7/6.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (fileCaches)

-(NSUInteger) getFileSize;

-(NSUInteger) getImageSize;

-(void) clearImageCache;

@end
