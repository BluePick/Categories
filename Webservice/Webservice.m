
#import "Webservice.h"
#import "JSON.h"
@class AppDelegate;

@implementation Webservice
@synthesize _delegate;
@synthesize iTag;
@synthesize isPdf;
@synthesize complete;
@synthesize busy;
@synthesize responseProper;
@synthesize webserviceType;
@synthesize PDFfileName;

-(void)callJSONMethod:(NSString *)methodName withParameters: (NSMutableDictionary *) params
{
    complete = NO;
    busy = YES;
	NSURL *url=	[NSURL URLWithString:WEBSERVICE_URL];
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url]; 
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strRequest = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
	strRequest = [NSString stringWithFormat:@"json=%@",strRequest];
	NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];

	mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

-(void)callJSONMethod:(NSString *)methodName withImage:(NSData*)imageData andParams:(NSMutableDictionary*)params{
    complete = NO;
    busy = YES;
    NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",methodName];
    NSArray *array = [params allKeys];
	NSInteger i= 0;
    NSString *strRequest = @"";
	for (NSString *strKey in array){
		NSString *strValue = [params objectForKey:strKey];
		if (i==0) 
			strRequest = [strRequest stringByAppendingFormat:@"?%@=%@",strKey,strValue];
		else 
			strRequest = [strRequest stringByAppendingFormat:@"&%@=%@",strKey,strValue];
		i++;
	}
    
    strURL = [strURL stringByAppendingFormat:@"%@",strRequest];
    NSLog(@"%@",strURL);
    NSURL *url=	[NSURL URLWithString:strURL];
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
	NSString *boundary = [NSString stringWithFormat:@"%@",@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",@"Content-Disposition: attachment; name=\"pi_uploaded_image\"; filename=\"temp.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"%@",@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)callJSONGETWebserviceMethod:(NSString*)methodName withParams:(NSMutableDictionary*)dict{
    complete = NO;
    busy = YES;
	NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",methodName];
	NSArray *array = [dict allKeys];
	NSInteger i= 0;
	for (NSString *strKey in array){
		NSString *strValue = [dict objectForKey:strKey];
		if (i==0) 
			strURL = [strURL stringByAppendingFormat:@"?%@=%@",strKey,strValue];
		else 
			strURL = [strURL stringByAppendingFormat:@"&%@=%@",strKey,strValue];
		i++;
	}
	strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"%@",strURL);
	
	mutableData = [NSMutableData data];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
 //  NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
 //  [request addValue:cookie forHTTPHeaderField:@"Cookie"];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void)callGetWebserviceMethod:(NSString*)method withParams:(NSMutableDictionary*)dict{
	complete = NO;
    busy = YES;
	NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",method];
	NSArray *array = [dict allKeys];
	NSInteger i= 0;
	for (NSString *strKey in array){
		NSString *strValue = [dict objectForKey:strKey];
		if (i==0)
			strURL = [strURL stringByAppendingFormat:@"?%@=%@",strKey,strValue];
		else
			strURL = [strURL stringByAppendingFormat:@"&%@=%@",strKey,strValue];
		i++;
	}
	strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",strURL);
    if(mutableData){
//        [mutableData release];
        mutableData = nil;
    }
    if(conn){
        [conn cancel];
//        [conn release];
        conn = nil;
    }
	mutableData = [NSMutableData data];
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)callPDFGetWebserviceMethod:(NSString*)method withParams:(NSMutableDictionary*)dict withFilename:(NSString *)FileName{
	complete = NO;
    busy = YES;
    self.PDFfileName = FileName;
	NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",method];
	NSArray *array = [dict allKeys];
	NSInteger i= 0;
	for (NSString *strKey in array){
		NSString *strValue = [dict objectForKey:strKey];
		if (i==0)
			strURL = [strURL stringByAppendingFormat:@"?%@=%@",strKey,strValue];
		else
			strURL = [strURL stringByAppendingFormat:@"&%@=%@",strKey,strValue];
		i++;
	}
	strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",strURL);
    if(mutableData){
//        [mutableData release];
        mutableData = nil;
    }
    if(conn){
        [conn cancel];
//        [conn release];
        conn = nil;
    }
	mutableData = [NSMutableData data];
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



-(void)callPostWebservice:(NSMutableDictionary*)params forMethod:(NSString*)method{
    complete = NO;
    busy = YES;
    
	NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",method];
    
    NSString *strParams = @"";
    NSArray *array = [params allKeys];
	NSInteger i= 0;
	for (NSString *strKey in array){
		NSString *strValue = [params objectForKey:strKey];
		if (i==0)
			strParams = [strParams stringByAppendingFormat:@"%@=%@",strKey,strValue];
		else
			strParams = [strParams stringByAppendingFormat:@"&%@=%@",strKey,strValue];
		i++;
	}
    NSLog(@"%@",strURL);
    NSURL *url=	[NSURL URLWithString:strURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	NSData *data = [strParams dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];
    
    NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    
	mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void)callPostWebserviceForHTMLForm:(NSMutableDictionary*)params forMethod:(NSString*)method{
    complete = NO;
    busy = YES;
    
	NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",method];
    
//    NSString *strParams = @"";
//    NSArray *array = [params allKeys];
//	NSInteger i= 0;
//	for (NSString *strKey in array){
//		NSString *strValue = [params objectForKey:strKey];
//		if (i==0)
//			strParams = [strParams stringByAppendingFormat:@"%@=%@",strKey,strValue];
//		else
//			strParams = [strParams stringByAppendingFormat:@"&%@=%@",strKey,strValue];
//		i++;
//	}
    NSLog(@"%@",strURL);
    NSURL *url=	[NSURL URLWithString:strURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
     NSLog(@"jsonData as string:\n%@", jsonString);
    
	NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];
    
    NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    
	mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void)postJSONString:(NSString*)strData forMethod:(NSString*)method{
    complete = NO;
    busy = YES;
	NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",method];
    NSLog(@"%@",strURL);
    NSURL *url=	[NSURL URLWithString:strURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];
    
    NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    
	mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)postSignatureImageData:(NSData*)data forMethod:(NSString*)method{
    complete = NO;
    busy = YES;
	NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",method];
    NSURL *url=	[NSURL URLWithString:strURL];
    NSLog(@"%@",strURL);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:data];
	mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSMutableData*)generatePostBody:(NSMutableDictionary *)_params bodyLength:(int *)length {
    
    NSString *BOUNDARY = @"---------------------------7d92ff162077c";
    NSMutableData* body = [NSMutableData data];
    NSString* endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (id key in [_params keyEnumerator]) {
        if (![[_params objectForKey:key] isKindOfClass:[NSData class]]) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[_params valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    for (id key in [_params keyEnumerator]) {        
        if ([[_params objectForKey:key] isKindOfClass:[NSData class]]) {
            NSData *textData = [_params objectForKey:key];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media_data\"; filename=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:textData];
            continue;
            
        }
        
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    *length = (int)[body length];
    return body;
    
}

-(void)callpostImage:(NSData*)imageData andParams:(NSMutableDictionary*)params extension:(NSString*)extension{
    complete = NO;
    busy = YES;
    NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",extension];
    NSURL *url=	[NSURL URLWithString:strURL];
    NSLog(@"%@",strURL);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *BOUNDARY = @"---------------------------7d92ff162077c";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSInteger itemp;
    [params setObject:imageData forKey:@"testimage"];
    NSMutableData *body = [self generatePostBody:params bodyLength:(int *)&itemp];
    [request addValue:[NSString stringWithFormat:@"%d", (int)itemp] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (NSMutableData*)generatePostBodyforPDF:(NSMutableDictionary *)_params bodyLength:(int *)length {
    
    NSString *BOUNDARY = @"---------------------------7d92ff162077c";
    NSMutableData* body = [NSMutableData data];
    NSString* endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (id key in [_params keyEnumerator]) {
        if (![[_params objectForKey:key] isKindOfClass:[NSData class]]) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[_params valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    for (id key in [_params keyEnumerator]) {
        if ([[_params objectForKey:key] isKindOfClass:[NSData class]]) {
            NSData *textData = [_params objectForKey:key];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media_data\"; filename=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",@"Content-Type: application/pdf\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:textData];
            continue;
            
        }
        
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    *length = (int)[body length];
    return body;
    
}

-(void)callpostPdf:(NSData*)PdfData andParams:(NSMutableDictionary*)params extension:(NSString*)extension{
    complete = NO;
    busy = YES;
    NSString *strURL = [WEBSERVICE_URL stringByAppendingFormat:@"%@",extension];
    NSURL *url=	[NSURL URLWithString:strURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *BOUNDARY = @"---------------------------7d92ff162077c";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSInteger itemp;
    [params setObject:PdfData forKey:@"testPDf"];
    NSMutableData *body = [self generatePostBodyforPDF:params bodyLength:(int *)&itemp];
    [request addValue:[NSString stringWithFormat:@"%d", (int)itemp] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    NSString *cookie= [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCookie"];
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}






-(void)cancelWebservice{
    busy = NO;
    if(mutableData){
//        [mutableData release];
        mutableData = nil;
    }
    if(conn){
        [conn cancel];
//        [conn release];
        conn = nil;
    }
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)conection didReceiveResponse:(NSURLResponse *)response{
  //  NSHTTPURLResponse *httpResponse;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(webserviceType==1){
        NSDictionary *fields = [httpResponse allHeaderFields];
        NSString *cookie = [fields objectForKey:@"Set-Cookie"];
        [[NSUserDefaults standardUserDefaults] setObject:cookie forKey:@"MyCookie"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
	httpResponse = (NSHTTPURLResponse *)response;
	assert([httpResponse isKindOfClass:[NSHTTPURLResponse class]]);
    
	if ((httpResponse.statusCode / 100) != 2) {
//        NSLog(@"httpResponse.statusCode ========= %d",httpResponse.statusCode);
		responseProper = NO;
//
//        complete = YES;
//        busy = NO;
//        if(mutableData){
//            [mutableData release];
//            mutableData = nil;
//        }
//        if(conn){
//            [conn release];
//            conn = nil;
//        }
//        if ([_delegate respondsToSelector:@selector(failWithWebServiceError:)])
//            [_delegate failWithWebServiceError:nil];
//        else if([_delegate respondsToSelector:@selector(failWithWebService:error:)])
//            [_delegate failWithWebService:self error:nil];

	} 
	else
    {
        expectedContentLength = response.expectedContentLength;
        responseProper = YES;
        [mutableData setLength:0];
	}
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [mutableData appendData:data];
//    if ([_delegate respondsToSelector:@selector(dataLoadedPercentage:withWebservice:)]) {
//        double dPercentage = (mutableData.length*100)/expectedContentLength;
//		[_delegate dataLoadedPercentage:dPercentage withWebservice:self];
//	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    complete = YES;
     busy = NO;
    if(mutableData){
//		[mutableData release];
		mutableData = nil;
	}
	if(conn){
//		[conn release];
		conn = nil;
	}
	
	if ([_delegate respondsToSelector:@selector(failWithWebServiceError:)]) {
		[_delegate failWithWebServiceError:error];
	}
    else if([_delegate respondsToSelector:@selector(failWithWebService:error:)]){
        [_delegate failWithWebService:self error:error];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    complete = YES;
    busy = NO;
	NSString* returnString = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSError *jsonError = nil;
    NSDictionary *dict = nil;
    if(mutableData)
        dict = [NSJSONSerialization JSONObjectWithData:mutableData options:NSJSONReadingMutableContainers error:&jsonError];
    if (!dict)
        NSLog(@"%@",returnString);
    
    if (self.webserviceType == getFieldsWebservice){
        returnString = [returnString stringByReplacingOccurrencesOfString:@"\\\\" withString:@""];
        returnString = [returnString stringByReplacingOccurrencesOfString:@"\\" withString:@"\""];
        dict = [NSJSONSerialization JSONObjectWithData:[returnString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];

    }

    if (self.webserviceType == getSigPdfFileWebservice) {
        NSString *pdfPath = [self.PDFfileName pathInCacheDirectory];
        if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]){
            [[NSFileManager defaultManager] removeItemAtPath:pdfPath error:nil];
        }
        NSError *error = nil;
        BOOL isSuccess = [mutableData writeToFile:pdfPath options:0 error:&error];
        NSRange rangeValue = [returnString rangeOfString:@"error" options:NSCaseInsensitiveSearch];
        if (rangeValue.length > 0)
            isSuccess = NO;
        dict = [NSMutableDictionary dictionaryWithObject:isSuccess?@"1":@"0" forKey:@"status"];
    }
    
    if (self.webserviceType == getPdffileWebservice || self.webserviceType == getSketchPadWebservice) {
        NSString *pdfName = self.webserviceType == getPdffileWebservice?@"temp.pdf":@"sketch.png";
        NSString *pdfPath = [pdfName pathInCacheDirectory];
        if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]){
            [[NSFileManager defaultManager] removeItemAtPath:pdfPath error:nil];
        }
        NSError *error = nil;
        BOOL isSuccess = [mutableData writeToFile:pdfPath options:0 error:&error];
        NSRange rangeValue = [returnString rangeOfString:@"error" options:NSCaseInsensitiveSearch];
        if (rangeValue.length > 0)
            isSuccess = NO;
        dict = [NSMutableDictionary dictionaryWithObject:isSuccess?@"1":@"0" forKey:@"status"];
    }

    if(mutableData){
//		[mutableData release];
		mutableData = nil;
	}
    if(conn){
//		[conn release];
		conn = nil;
	}
    
    if(self.webserviceType == GetRAMQFeesWebservices){
        dict = [NSMutableDictionary dictionaryWithObject:returnString forKey:@"fees"];
    }
	if ([_delegate respondsToSelector:@selector(completeDownload:withWebservice:)]) {
		[_delegate completeDownload:dict withWebservice:self];
	}
}

-(void)dealloc{
    if(mutableData){
//		[mutableData release];
		mutableData = nil;
	}
	if(conn){
//		[conn release];
		conn = nil;
	}
//    [super dealloc];
}






@end
