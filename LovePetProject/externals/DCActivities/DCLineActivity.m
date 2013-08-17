//
//  DCLineActivity.m
//  DCActivities
//
// This is under The MIT License
//
// Copyright © 2012 Ha-Nyung Chung <minorblend@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "DCLineActivity.h"
#import "NSString+DCActivities.h"

static NSString *LineBaseURL = @"line://msg/text";

@implementation DCLineActivity {
    NSString *_message;
    NSURL *_url;
}

- (NSString *)activityType {
    return @"MBLineActivity";
}

- (NSString *)activityTitle {
    return @"Line";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"icon_line"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:LineBaseURL]];
}

- (void)performActivity {
    NSString *urlToOpen = [NSString stringWithFormat:@"%@/%@", LineBaseURL, [NSString stringWithFormat:@"%@%@", [_message URLEscapedString], _url.absoluteString]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
    
    [self activityDidFinish:YES];
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]] && !_message)
            _message = item;
        else if ([item isKindOfClass:[NSURL class]] && !_url)
            _url = item;
    }
}

@end
