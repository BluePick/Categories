

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "NSString+Extensions.h"

typedef enum {
    DefautWebservice                    = 0,
    LoginWebservice                     = 1,
    PatientListWebservice               = 2,
    GetDiagnosticsWebservice            = 3,
    GetFavouriteDiagnosticsWebservice   = 4,
    GetMedicalActsWebservice            = 5,
    GetFavouriteActsWebservice          = 6,
    GetPatientByRAMQWebservice          = 7,
    GetRAMQFeesWebservices              = 8,
    getPdffileWebservice                = 9,
    getSketchPadWebservice              = 10,
    getFieldsWebservice                 = 11,
    getSigPdfFileWebservice             = 12

	
} WebServiceType;

@protocol WebserviceDelegate;

@interface Webservice : NSObject <UIAlertViewDelegate>{
	NSURLConnection *conn;
	NSMutableData *mutableData;
	__unsafe_unretained id <WebserviceDelegate> _delegate;
	NSInteger iTag;
    NSInteger isPdf;
    BOOL complete;
    BOOL busy;
    long long expectedContentLength;
    BOOL responseProper;
    NSString *PDFfileName;
    WebServiceType webserviceType;
}
@property (nonatomic, assign) id <WebserviceDelegate> _delegate;
@property (nonatomic) NSInteger iTag;
@property (nonatomic) NSInteger isPdf;
@property (nonatomic) BOOL complete;
@property (nonatomic) BOOL busy;
@property (nonatomic) BOOL responseProper;
@property (nonatomic) WebServiceType webserviceType;
@property (nonatomic,retain)  NSString *PDFfileName;

-(void)callJSONMethod: (NSString *)methodName withParameters: (NSMutableDictionary *) params;
-(void)callJSONMethod:(NSString *)methodName withImage:(NSData*)imageData andParams:(NSMutableDictionary*)params;
-(void)callJSONGETWebserviceMethod:(NSString*)methodName withParams:(NSMutableDictionary*)dict;
-(void)callpostImage:(NSData*)imageData andParams:(NSMutableDictionary*)params extension:(NSString*)extension;
-(void)callGetWebserviceMethod:(NSString*)method withParams:(NSMutableDictionary*)dict;
//changes
-(void)callPDFGetWebserviceMethod:(NSString*)method withParams:(NSMutableDictionary*)dict withFilename:(NSString *)FileName;
-(void)postJSONString:(NSString*)strData forMethod:(NSString*)method;
-(void)postSignatureImageData:(NSData*)data forMethod:(NSString*)method;

-(void)callPostWebservice:(NSMutableDictionary*)params forMethod:(NSString*)method;
-(void)callPostWebserviceForHTMLForm:(NSMutableDictionary*)params forMethod:(NSString*)method;
-(void)cancelWebservice;

-(void)callpostPdf:(NSData*)PdfData andParams:(NSMutableDictionary*)params extension:(NSString*)extension;

@end

@protocol WebserviceDelegate <NSObject>
@optional
-(void)completeDownload:(id)dict withWebservice:(Webservice*)service;
-(void)dataLoadedPercentage:(CGFloat)fLoaded withWebservice:(Webservice*)service;
-(void)failWithWebService:(Webservice*)service error:(NSError*)error;
-(void)failWithWebServiceError:(NSError*)error;
@end
