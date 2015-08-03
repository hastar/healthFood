//
//  NSString+fileCaches.m
//  文件缓存Demo
//
//  Created by lanou on 15/7/6.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "NSString+fileCaches.h"

#define NSImageFile @[@"jpg", @"png", @"gif", @"jpeg", @"bmp", @"raw"]
#define kIsImageFile(extension) [NSImageFile containsObject:extension]

@implementation NSString (fileCaches)

-(NSUInteger)getFileSize
{
    
    NSUInteger size = 0;
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //判断是否为文件/文件夹路径
    BOOL isFile =[mgr fileExistsAtPath:self];
    if (!isFile) {
        return  0;
    }
    
    //获取所有子文件夹路径
    NSArray *fileArray = [mgr subpathsAtPath:self];
    for (NSString *subPath in fileArray) {
        NSString *subFullPath = [self stringByAppendingPathComponent:subPath];
        
        //判断是否为子文件夹
        BOOL isDir = NO;
        
        
        [mgr fileExistsAtPath:subFullPath isDirectory:&isDir];
        if (isDir) {
            continue;
        }
        
        
        //获取文件属性
        NSDictionary *attrDic = [mgr attributesOfItemAtPath:subFullPath error:nil];
        NSLog(@"attrDic = %@", attrDic);
        size += [attrDic[NSFileSize] integerValue];
    }
    
    
    return size;
}

-(NSUInteger) getImageSize
{
    NSUInteger size = 0;
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //判断是否为文件/文件夹路径
    BOOL isFile =[mgr fileExistsAtPath:self];
    if (!isFile) {
        return  0;
    }
    
    //获取所有子文件夹路径
    NSArray *fileArray = [mgr subpathsAtPath:self];
    for (NSString *subPath in fileArray) {
        NSString *subFullPath = [self stringByAppendingPathComponent:subPath];
        
        //判断是否为子文件夹
        BOOL isDir = NO;
        [mgr fileExistsAtPath:subFullPath isDirectory:&isDir];
        if (isDir) {
            continue;
        }
        
        if ([subFullPath isImageFile]) {
            //获取文件属性
            NSDictionary *attrDic = [mgr attributesOfItemAtPath:subFullPath error:nil];
            size += [attrDic[NSFileSize] integerValue];
        }

    }
    
    
    return size;

}

-(BOOL)isImageFile
{
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isFile = NO;
    BOOL isFilePath = [mgr fileExistsAtPath:self isDirectory:&isFile];
    
    Byte pngHead[] = {0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a};
    Byte gifHead[] = {0x47, 0x49, 0x46, 0x38, 0x39, 0x61};
    Byte jpegHead[]= {0xff, 0xd8};
    Byte icoHead[] = {0x00, 0x00, 0x01,0x00,0x01, 0x00, 0x20, 0x20};
    
    if (isFilePath && !isFile)
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:self];
        if (data.length == 0 || sizeof(data.bytes) == 0) return NO;
        if (memcmp(data.bytes, pngHead, sizeof(pngHead)) == 0||
            memcmp(data.bytes, gifHead, sizeof(gifHead)) == 0 ||
            memcmp(data.bytes, jpegHead, sizeof(jpegHead)) == 0 ||
            memcmp(data.bytes, icoHead, sizeof(icoHead))) {
            
            return YES;
            
        }
    }
    
    return NO;
}

-(void)clearImageCache
{
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //判断是否为文件/文件夹路径
    BOOL isFile =[mgr fileExistsAtPath:self];
    if (!isFile) {
        return  ;
    }
    
    //获取所有子文件夹路径
    NSArray *fileArray = [mgr subpathsAtPath:self];
    for (NSString *subPath in fileArray) {
        NSString *subFullPath = [self stringByAppendingPathComponent:subPath];
        
        if ([subFullPath isImageFile]) {
            //获取文件属性
            
            if ([mgr isDeletableFileAtPath:subFullPath]) {
                [mgr removeItemAtPath:subFullPath error:nil];
            }
            else
            {
                NSLog(@"Don't delete imageFile is %@", subFullPath);
            }
        }
        
    }
    
}


@end
