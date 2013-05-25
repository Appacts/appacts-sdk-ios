#import <Foundation/Foundation.h>

@interface ScreenResolution : NSObject

{
    NSInteger Width;
    NSInteger Height;
}

@property (nonatomic) NSInteger Width;
@property (nonatomic) NSInteger Height;

-(id)initWithScreenWidth:(NSInteger) anScreenWidth screenHeight:(NSInteger) anScreenHeight;

@end
