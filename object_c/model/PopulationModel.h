#import "BaseModel.h"
@interface PopulationModel : BaseModel
@property (assign) double population;
@property (assign) NSInteger year;
@property (assign) NSInteger id_year;
@property (copy) NSString *id_nation;
@property (copy) NSString *nation;
@property (copy) NSString *slug_nation;
@end
