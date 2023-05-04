//
//  OpenCVWrapper.h
//  OpenCVSwift
//
//  Created by Rashed Sahajee on 25/03/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;
+ (UIImage *)lineDectection : (UIImage *) input;

- (UIImage *)applyHougTransForm: (UIImage *) inputImage;

@end

NS_ASSUME_NONNULL_END
