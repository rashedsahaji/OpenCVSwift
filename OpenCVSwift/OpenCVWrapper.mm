//
//  OpenCVWrapper.m
//  OpenCVSwift
//
//  Created by Rashed Sahajee on 25/03/23.
//

#import "OpenCVWrapper.h"
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import "UIImage+Rotate.h"
#import "UIImage+OpenCV.h"

@implementation OpenCVWrapper

+ (NSString *)openCVVersionString {
return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

+ (UIImage *)lineDectection : (UIImage *) input {
    // Define the boundaries
    cv::Scalar lower(180, 180, 100);
    cv::Scalar upper(255, 255, 255);
    
    // Load the image
    UIImage* rotatedImage = [input rotateToImageOrientation];
    cv::Mat image = [rotatedImage CVMat3];
    
    // Convert the boundaries to a cv::Mat
    cv::Mat lowerMat = cv::Mat(1, 1, CV_8UC4, lower);
    cv::Mat upperMat = cv::Mat(1, 1, CV_8UC4, upper);
    
    // Convert the image to the HSV color space
    cv::Mat hsvImage;
    cv::cvtColor(image, hsvImage, cv::COLOR_BGR2HSV);
    
    // Apply the mask
    cv::Mat mask;
    cv::inRange(hsvImage, lowerMat, upperMat, mask);
    
    // Apply the mask to the image
    cv::Mat output;
    cv::bitwise_and(image, image, output);
    
    //Output
    image.copyTo(output, mask);
    
    // Grey Out
    cv::Mat grey;
    cv::cvtColor(image, grey, cv::COLOR_BGR2GRAY);
    
    // Blur
    cv::Mat blur;
    int kernel = 5;
    cv::GaussianBlur(grey, blur, cv::Size(kernel, kernel), 0);
    
    //Canny
    cv::Mat edges;
    cv::Canny(blur, edges, 10, 200);
    
    //dilates
    cv::Mat element = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(2, 2));
    cv::Mat detailed;
    cv::dilate(edges, detailed, element);
    
    // Real Thing is Happening Here
    double rho = 1; // distance resolution in pixels of the Hough grid
    double theta = CV_PI / 180; // angular resolution in radians of the Hough grid
    int threshold = 10; // minimum number of votes (intersections in Hough grid cell)
    double min_line_length = 40; // minimum number of pixels making up a line
    double max_line_gap = 5; // maximum gap in pixels between connectable line segments
    cv::Mat line_image = cv::Mat::zeros(output.size(), output.type()); // creating a blank to draw lines on
    
    // Run Hough on edge detected image
    // Output "lines" is an array containing endpoints of detected line segments
    
    std::vector<cv::Vec4i> lines;
    cv::HoughLinesP(detailed, lines, rho, theta, threshold, min_line_length, max_line_gap);
    
    // Draw detected lines on the image
    for (size_t i = 0; i < lines.size(); i++) {
        cv::Vec4i line = lines[i];
        cv::Point pt1(line[0], line[1]);
        cv::Point pt2(line[2], line[3]);
        cv::line(line_image, pt1, pt2, cv::Scalar(255, 0, 0), 5);
    }
    
    
    cv::Mat lines_edges;
    cv::addWeighted(output, 0.8, line_image, 1, 0, lines_edges);
    
    // Convert the output to a UIImage and display it
    UIImage *uiImage = [UIImage imageWithCVMat:lines_edges];
    
    return uiImage;
}

@end
