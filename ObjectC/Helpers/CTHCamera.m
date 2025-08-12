#import <MobileCoreServices/UTCoreTypes.h>
@implementation CTHCamera
+(instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(void)actionPhoto:(UIViewController*)viewController Delegate:(id)delegate{
    if (!self.imgArray)
        self.imgArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.imgArray removeAllObjects];
    self.viewController = viewController;
    self.delegate = delegate;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[CTHLanguage language:@"choose attached photo" Text:@"CHOOSE ATTACHED PHOTO"]  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:[CTHLanguage language:@"cancel" Text:@"CANCEL"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addAction:[UIAlertAction actionWithTitle:[CTHLanguage language:@"take a photo" Text:@"TAKE A PHOTO"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.delegate = self;
            self.imagePickerController.allowsEditing = YES;
            [self.viewController.navigationController presentViewController:self.imagePickerController animated:YES completion:nil];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:[CTHLanguage language:@"choose from camera roll" Text:@"CHOOSE FROM CAMERA ROLL"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.delegate = self;
        self.imagePickerController.allowsEditing = YES;
        [self.viewController.navigationController presentViewController:self.imagePickerController animated:YES completion:nil];
    }]];
    [self.viewController presentViewController:actionSheet animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    img = [self fixRotation:img];
    if (!self.imgArray)
        self.imgArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSData *someImageData = UIImagePNGRepresentation(img);
    [self.imgArray addObject:someImageData];
    [self.viewController.navigationController dismissViewControllerAnimated:YES completion:^{ }];
    self.imagePickerController = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCompleted:)]) {
        [self.delegate photoCompleted:self];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (self.imagePickerController) {
        [self.viewController.navigationController dismissViewControllerAnimated:YES completion:^{ }];
        self.imagePickerController = nil;
    }
}
-(void)clear{
    [self.imgArray removeAllObjects];
}
-(UIImage *)fixRotation:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
            break;
    }
    switch (image.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end

