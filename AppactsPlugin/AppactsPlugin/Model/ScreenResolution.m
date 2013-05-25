#import "ScreenResolution.h"

@implementation ScreenResolution

@synthesize Width;
@synthesize Height;

-(id) initWithScreenWidth:(NSInteger) anScreenWidth screenHeight:(NSInteger) anScreenHeight
{
    self.Width = anScreenWidth;
    self.Height = anScreenHeight;
    
    return self;
}

@end
