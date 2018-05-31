/**
 * Cobub Razor
 *
 * An open source analytics iphone sdk for mobile applications
 *
 * @package		Cobub Razor
 * @author		WBTECH Dev Team
 * @copyright	Copyright (c) 2011 - 2012, NanJing Western Bridge Co.,Ltd.
 * @license		http://www.cobub.com/products/cobub-razor/license
 * @link		http://www.cobub.com/products/cobub-razor/
 * @since		Version 0.1
 * @filesource
 */

#import <Foundation/Foundation.h>
#import "ConfigPreference.h"

@interface ConfigDao : NSObject
{
}
/*
 Get system online config params
 */
+ (ConfigPreference *)getOnlineConfig:(NSString *) appkey;

/*
 Get developer custom params
 */
+ (void)getCustomParams:(NSString*)appkey;

@end
