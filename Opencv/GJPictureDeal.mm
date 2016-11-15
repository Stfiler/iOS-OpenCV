//
//  GJPictureDeal.m
//  Opencv
//
//  Created by xudesong on 16/10/8.
//  Copyright © 2016年 xudesong. All rights reserved.
//

#import "GJPictureDeal.h"

#import <ImageIO/ImageIO.h>

#import "UIImageCVMatConverter.h"

#import "imageFilter.h"

@implementation GJPictureDeal

+ (UIImage *)UIImageFromMat: (cv:: Mat)cvMat
{
    return [UIImageCVMatConverter UIImageFromCVMat: cvMat];
}

+ (cv:: Mat)MatFromUIImage: (UIImage *)image
{
    return [UIImageCVMatConverter cvMatFromUIImage: image];
}

+ (NSDictionary *)getImageInfo: (NSURL *)imageURL
{
    CGImageSourceRef imageRef = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: NO], (__bridge NSString *)kCGImageSourceShouldCache, nil];
    
    return (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageRef, 0, NULL);
}


#pragma mark -Opencv效果

//0: 打码 （0- 14）
+ (UIImage *)setOpencvDamaImage: (UIImage *)inputImage value: (NSInteger) value
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 0 sliderValueOne: value sliderValueTwo: 0];
}


//5: 固定阈值门限分割
+ (UIImage *)setOpencvThresholdImage: (UIImage *)inputImage value: (NSInteger) value
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 5 sliderValueOne: value sliderValueTwo: 0];
}

//10:  亮度控制 第一个参数为 0 ~ 100 （0） 第二个参数 0 ~ 1 (0.3-1)
+ (UIImage *)setOpencvLiangduImage: (UIImage *)inputImage value1: (float) value1 value2: (float) value2
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 10 sliderValueOne: value1 sliderValueTwo: value2];
}

//1: 卡通
+ (UIImage *)setOpencvKatong: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 1 sliderValueOne: 0 sliderValueTwo: 0];
}

//2: 黑白
+ (UIImage *)setOpencvHeibai: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 2 sliderValueOne: 0 sliderValueTwo: 0];
}

//3: 软焦距 （美颜）
+ (UIImage *)setOpencvMeiYan: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 3 sliderValueOne: 0 sliderValueTwo: 0];
}

//4: 翻转 inverse
+ (UIImage *)setOpencvInverse: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 4 sliderValueOne: 0 sliderValueTwo: 0];
}

//6: 柔和怀旧
+ (UIImage *)setOpencvHuaiJiu: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 6 sliderValueOne: 0 sliderValueTwo: 0];
}

//7: 铅笔素描
+ (UIImage *)setOpencvQianBi: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 7 sliderValueOne: 0 sliderValueTwo: 0];
}

//8: 复古老照片
+ (UIImage *)setOpencvFuGu: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 8 sliderValueOne: 0 sliderValueTwo: 0];
}

//9: 焦距微粒
+ (UIImage *)setOpencvJuJiao: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 9 sliderValueOne: 0 sliderValueTwo: 0];
}

//11: 彩色写生
+ (UIImage *)setOpencvCaiSeXieSheng: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 11 sliderValueOne: 0 sliderValueTwo: 0];
}

//12: 针孔效果
+ (UIImage *)setOpencvZhenKong: (UIImage *)inputImage
{
    imageFilter *filter = [[imageFilter alloc] init];
    return [filter processImage:inputImage oldImage:inputImage number: 12 sliderValueOne: 0 sliderValueTwo: 0];
}


#pragma mark -原生实现的功能
+ (UIImage *)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)scaleImage: (UIImage *)image ViewSize: (CGSize) viewSize scaleRect: (CGRect) scaleRect
{
    UIGraphicsBeginImageContext(viewSize);
    
    [image drawInRect: scaleRect];
    
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaleImage;
}














//--------------------------------------------------圆角

//预先生成圆角图片，直接渲染到UIImageView中去，相比直接在UIImageView.layer中去设置圆角，可以缩短渲染时间。

/**
 *  在原图的四周生成圆角，得到带圆角的图片
 *
 *  @param image           原图
 *  @param width           圆角大小
 *  @param backgroundcolor 背景颜色
 *
 *  @return 新生成的图片
 */
+(UIImage *)getCornerImageAtOriginalImageCornerWithImage:(UIImage *)image
                                           andCornerWith:(CGFloat)width
                                      andBackGroundColor:(UIColor *)backgroundcolor
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
    CGRect bounds = CGRectMake(0,
                               0,
                               image.size.width,
                               image.size.height);
    
    
    CGRect rect   = CGRectMake(0,
                               0,
                               image.size.width,
                               image.size.height);
    
    [backgroundcolor set];
    UIRectFill(bounds);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width] addClip];
    
    [image drawInRect:bounds];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  根据Size生成圆角图片，图片会拉伸-变形
 *
 *  @param Size            最终想要的图片的尺寸
 *  @param image           原图
 *  @param width           圆角大小
 *  @param backgroundcolor 背景颜色
 *
 *  @return 新生成的图片
 */
+(UIImage *)getCornerImageFitSize:(CGSize)Size
                        WithImage:(UIImage *)image
                    andCornerWith:(CGFloat)width
               andBackGroundColor:(UIColor *)backgroundcolor
{
    
    UIGraphicsBeginImageContextWithOptions(Size, NO, 0.0);
    
    
    CGRect bounds = CGRectMake(0,
                               0,
                               Size.width,
                               Size.height);
    
    CGRect rect   = CGRectMake(0,
                               0,
                               Size.width,
                               Size.height);
    
    [backgroundcolor set];
    UIRectFill(bounds);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width] addClip];
    
    [image drawInRect:bounds];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  根据Size生成圆角图片，图片会自适应填充，伸展范围以外的部分会被裁剪掉-不会变形
 *
 *  @param Size            最终想要的图片的尺寸
 *  @param image           原图
 *  @param width           圆角大小
 *  @param backgroundcolor 背景颜色
 *
 *  @return 新生成的图片
 */
+(UIImage *)getCornerImageFillSize:(CGSize)Size
                         WithImage:(UIImage *)image
                     andCornerWith:(CGFloat)width
                andBackGroundColor:(UIColor *)backgroundcolor

{
    UIGraphicsBeginImageContextWithOptions(Size, NO, 0.0);
    
    CGFloat bili_imageWH = image.size.width/image.size.height;
    CGFloat bili_SizeWH  = Size.width/Size.height;
    
    CGRect bounds;
    
    if (bili_imageWH > bili_SizeWH) {
        
        CGFloat bili_SizeH_imageH = Size.height/image.size.height;
        
        CGFloat height = image.size.height*bili_SizeH_imageH;
        
        CGFloat width = height * bili_imageWH;
        
        CGFloat x = -(width - Size.width)/2;
        
        CGFloat y = 0;
        
        bounds = CGRectMake(x,
                            y,
                            width,
                            height);
    }else{
        
        CGFloat bili_SizeW_imageW = Size.width/image.size.width;
        
        CGFloat width = image.size.width * bili_SizeW_imageW;
        
        CGFloat height = width / bili_imageWH;
        
        CGFloat x = 0;
        
        CGFloat y = -(height - Size.height)/2;
        
        bounds = CGRectMake(x,
                            y,
                            width,
                            height);
        
    }
    
    CGRect rect   = CGRectMake(0,
                               0,
                               Size.width,
                               Size.height);
    
    
    [backgroundcolor set];
    UIRectFill(bounds);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:width] addClip];
    
    [image drawInRect:bounds];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark --------水印
//--------------------------------------------------水印
/**
 *  生成带水印的图片
 *
 *  @param backImage  背景图片
 *  @param waterImage 水印图片
 *  @param waterRect  水印位置及大小
 *  @param alpha      水印透明度
 *  @param waterScale 水印是否根据Rect改变长宽比
 *
 *  @return 新生成的图片
 */
+(UIImage *)GetWaterPrintedImageWithBackImage:(UIImage *)backImage
                                andWaterImage:(UIImage *)waterImage
                                       inRect:(CGRect)waterRect
                                        alpha:(CGFloat)alpha
                                   waterScale:(BOOL)waterScale
{
    //说明，在最后UIImageView转UIImage的时候，View属性的size会压缩成1倍像素的size,所以本方法内涉及到Size的地方需要乘以2或3，才能保证最后的清晰度
    
    //默认制作X2像素，也可改成3或其它
    CGFloat clear = 2;
    
    UIImageView *backIMGV = [[UIImageView alloc]init];
    backIMGV.backgroundColor = [UIColor clearColor];
    backIMGV.frame = CGRectMake(0,
                                0,
                                backImage.size.width*clear,
                                backImage.size.height*clear);
    backIMGV.contentMode = UIViewContentModeScaleAspectFill;
    backIMGV.image = backImage;
    
    UIImageView *waterIMGV = [[UIImageView alloc]init];
    waterIMGV.backgroundColor = [UIColor clearColor];
    waterIMGV.frame = CGRectMake(waterRect.origin.x*clear,
                                 waterRect.origin.y*clear,
                                 waterRect.size.width*clear,
                                 waterRect.size.height*clear);
    if (waterScale) {
        waterIMGV.contentMode = UIViewContentModeScaleToFill;
    }else{
        waterIMGV.contentMode = UIViewContentModeScaleAspectFill;
    }
    waterIMGV.alpha = alpha;
    waterIMGV.image = waterImage;
    
    [backIMGV addSubview:waterIMGV];
    
    UIImage *outImage = [self imageWithUIView:backIMGV];
    
    return outImage;
}

#pragma mark --------根据遮罩图形状裁剪
//--------------------------------------------------根据遮罩图形状裁剪
/**
 *  根据遮罩图片的形状，裁剪原图，并生成新的图片
 原图与遮罩图片宽高最好都是1：1。若比例不同，则会居中。
 若因比例问题达不到效果，可用下面的UIview转UIImage的方法，先制作1：1的UIview，然后转成UIImage使用此功能
 *
 *  @param MaskImage 遮罩图片：遮罩图片最好是要显示的区域为纯黑色，不显示的区域为透明色。
 *  @param Backimage 准备裁剪的图片
 *
 *  @return 新生成的图片
 */
+(UIImage *)creatImageWithMaskImage:(UIImage *)MaskImage andBackimage:(UIImage *)Backimage{
    
    CGRect rect;
    
    if (Backimage.size.height>Backimage.size.width) {
        rect     = CGRectMake(0,
                              (Backimage.size.height-Backimage.size.width),
                              Backimage.size.width*2,
                              Backimage.size.width*2);
    }else{
        rect     = CGRectMake((Backimage.size.width-Backimage.size.height),
                              0,
                              Backimage.size.height*2,
                              Backimage.size.height*2);
    }
    
    
    NSLog(@"%f",(Backimage.size.height-Backimage.size.height)/2);
    UIImage *cutIMG = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([Backimage CGImage], rect)];
    
    //遮罩图
    CGImageRef maskImage = MaskImage.CGImage;
    //原图
    CGImageRef originImage = cutIMG.CGImage;
    
    
    CGContextRef mainViewContentContext;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    // create a bitmap graphics context the size of the image
    
    mainViewContentContext = CGBitmapContextCreate (NULL,
                                                    rect.size.width,
                                                    rect.size.height,
                                                    8,
                                                    0,
                                                    colorSpace,
                                                    kCGImageAlphaPremultipliedLast);
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);
    if (mainViewContentContext==NULL)
    {
        NSLog(@"error");
    }
    
    CGContextClipToMask(mainViewContentContext,
                        CGRectMake(0,
                                   0,
                                   rect.size.width,
                                   rect.size.height),
                        maskImage);
    
    CGContextDrawImage(mainViewContentContext,
                       CGRectMake(0,
                                  0,
                                  rect.size.width,
                                  rect.size.height),
                       originImage);
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    // convert the finished resized image to a UIImage
    UIImage *theImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
    // image is retained by the property setting above, so we can
    // release the original
    CGImageRelease(mainViewContentBitmapContext);
    
    
    
    
    return theImage;
    
}

#pragma mark --------缩略图
//--------------------------------------------------缩略图
/**
 *  得到图片的缩略图
 *
 *  @param image 原图
 *  @param Size  想得到的缩略图尺寸
 *  @param Scale Scale为YES：原图会根据Size进行拉伸-会变形，Scale为NO：原图会根据Size进行填充-不会变形
 *
 *  @return 新生成的图片
 */
+(UIImage *)getThumbImageWithImage:(UIImage *)image andSize:(CGSize)Size Scale:(BOOL)Scale{
    
    UIGraphicsBeginImageContextWithOptions(Size, NO, 0.0);
    
    CGRect rect = CGRectMake(0,
                             0,
                             Size.width,
                             Size.height);
    if (!Scale) {
        
        CGFloat bili_imageWH = image.size.width/image.size.height;
        CGFloat bili_SizeWH  = Size.width/Size.height;
        
        if (bili_imageWH > bili_SizeWH) {
            
            CGFloat bili_SizeH_imageH = Size.height/image.size.height;
            
            CGFloat height = image.size.height*bili_SizeH_imageH;
            
            CGFloat width = height * bili_imageWH;
            
            CGFloat x = -(width - Size.width)/2;
            
            CGFloat y = 0;
            
            rect = CGRectMake(x,
                              y,
                              width,
                              height);
            
        }else{
            
            CGFloat bili_SizeW_imageW = Size.width/image.size.width;
            
            CGFloat width = image.size.width * bili_SizeW_imageW;
            
            CGFloat height = width / bili_imageWH;
            
            CGFloat x = 0;
            
            CGFloat y = -(height - Size.height)/2;
            
            rect = CGRectMake(x,
                              y,
                              width,
                              height);
            
        }
    }
    
    [[UIColor clearColor] set];
    UIRectFill(rect);
    
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark --------生成阴影
//--------------------------------------------------生成阴影
/**
 *  生成带阴影的图片
 *
 *  @param image     原图
 *  @param offset    横纵方向的偏移
 *  @param blurWidth 模糊程度
 *  @param Alpha     阴影透明度
 *  @param Color     阴影颜色
 *
 *  @return 新生成的图片
 */
+(UIImage *)creatShadowImageWithOriginalImage:(UIImage *)image
                              andShadowOffset:(CGSize)offset
                                 andBlurWidth:(CGFloat)blurWidth
                                     andAlpha:(CGFloat)Alpha
                                     andColor:(UIColor *)Color
{
    CGFloat Scale = 2;
    
    CGFloat width  = (image.size.width+offset.width+blurWidth*4)*Scale;
    CGFloat height = (image.size.height+offset.height+blurWidth*4)*Scale;
    if(offset.width<0){
        width  = (image.size.width-offset.width+blurWidth*4)*Scale;
    }
    if(offset.height<0){
        height = (image.size.height-offset.height+blurWidth*4)*Scale;
    }
    
    UIView *RootBackView = [[UIView alloc]initWithFrame:CGRectMake(0,0,
                                                                   width,
                                                                   height)];
    RootBackView.backgroundColor = [UIColor clearColor];
    
    UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(blurWidth*2*Scale,
                                                                          blurWidth*2*Scale,
                                                                          image.size.width*Scale,
                                                                          image.size.height*Scale)];
    if(offset.width<0){
        ImageView.frame = CGRectMake((blurWidth*2-offset.width)*Scale,
                                     ImageView.frame.origin.y,
                                     ImageView.frame.size.width,
                                     ImageView.frame.size.height);
    }
    if(offset.height<0){
        ImageView.frame = CGRectMake(ImageView.frame.origin.x,
                                     (blurWidth*2-offset.height)*Scale,
                                     ImageView.frame.size.width,
                                     ImageView.frame.size.height);
    }
    ImageView.backgroundColor = [UIColor clearColor];
    ImageView.layer.shadowOffset = CGSizeMake(offset.width*Scale, offset.height*Scale);
    ImageView.layer.shadowRadius = blurWidth*Scale;
    ImageView.layer.shadowOpacity = Alpha;
    ImageView.layer.shadowColor  = Color.CGColor;
    ImageView.image = image;
    
    [RootBackView addSubview:ImageView];
    
    //ImageView.transform = CGAffineTransformMakeRotation(3.1415926*0.25);
    //ImageView.transform = CGAffineTransformMakeScale(2, 2);
    
    UIImage *newImage = [self imageWithUIView:RootBackView];
    
    return newImage;
}

#pragma mark --------旋转
//--------------------------------------------------旋转
/**
 *  得到旋转后的图片
 *
 *  @param image 原图
 *  @param Angle 角度（0~360）
 *
 *  @return 新生成的图片
 */
+(UIImage  *)GetRotationImageWithImage:(UIImage *)image
                                 Angle:(CGFloat)Angle
{
    
    UIView *RootBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,
                                                                    image.size.width,
                                                                    image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation( Angle* M_PI / 180);
    RootBackView.transform = t;
    CGSize rotatedSize = RootBackView.frame.size;
    
    
    UIGraphicsBeginImageContext(rotatedSize);
    
    
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(theContext, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(theContext, Angle * M_PI / 180);
    CGContextScaleCTM(theContext, 1.0, -1.0);
    
    
    
    CGContextDrawImage(theContext,
                       CGRectMake(-image.size.width / 2,
                                  -image.size.height / 2,
                                  image.size.width,
                                  image.size.height),
                       [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark --------裁剪
//--------------------------------------------------裁剪
/**
 *  裁剪图片
 注：若裁剪范围超出原图尺寸，则会用背景色填充缺失部位
 *
 *  @param image     原图
 *  @param Point     坐标
 *  @param Size      大小
 *  @param backColor 背景色
 *
 *  @return 新生成的图片
 */
+(UIImage *)cutImageWithImage:(UIImage *)image
                      atPoint:(CGPoint)Point
                     withSize:(CGSize)Size
              backgroundColor:(UIColor *)backColor
{
    UIGraphicsBeginImageContextWithOptions(Size, NO, 0.0);
    
    CGRect bounds = CGRectMake(0,
                               0,
                               Size.width,
                               Size.height);
    
    CGRect rect   = CGRectMake(-Point.x,
                               -Point.y,
                               image.size.width,
                               image.size.height);
    
    
    [backColor set];
    UIRectFill(bounds);
    
    [image drawInRect:rect];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark --------UIView转图片，提前渲染
//--------------------------------------------------UIView转图片，提前渲染
/**
 *  把UIView渲染成图片
 注：由于ios的编程像素和实际显示像素不同，在X2和X3的retina屏幕设备上，使用此方法生成的图片大小将会被还原成1倍像素，
 从而导致再次显示到UIImageView上显示时，清晰度下降。所以使用此方法前，请先将要转换的UIview及它的所有SubView
 的frame里的坐标和大小都根据需要X2或X3。
 *
 *  @param view 想渲染的UIView
 *
 *  @return 渲染出的图片
 */
+(UIImage *)imageWithUIView:(UIView *)view
{
    //UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContext(CGSizeMake(view.bounds.size.width, view.bounds.size.height));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
}



@end
