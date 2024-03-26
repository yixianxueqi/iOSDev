//
//  HHVideoCompreeeTools.m
//  iosDev
//
//  Created by kingdee on 2024/3/25.
//

#import "HHVideoCompreeeTools.h"
#import <AVFoundation/AVFoundation.h>

@interface HHVideoCompreeeTools ()

@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, assign) BOOL audioFinished;
@property (nonatomic, assign) BOOL videoFinished;

@property (nonatomic, copy) NSURL *inputURL;
@property (nonatomic, copy) NSURL *outputURL;
@property (nonatomic, copy) void(^completion)(void);

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVAssetReader *assetReader;
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetReaderTrackOutput *assetReaderAudioOutput;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterAudioInput;
@property (nonatomic, strong) AVAssetReaderTrackOutput *assetReaderVideoOutput;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterVideoInput;


@property (nonatomic, strong) dispatch_group_t dispatchGroup;
@property (nonatomic, strong) dispatch_queue_t mainSerializationQueue;
@property (nonatomic, strong) dispatch_queue_t rwAudioSerializationQueue;
@property (nonatomic, strong) dispatch_queue_t rwVideoSerializationQueue;

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) unsigned long long originSize;
@property (nonatomic, assign) unsigned long long compressSize;

@end

@implementation HHVideoCompreeeTools

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"HHVideoCompreeeTools dealloc...");
    self.asset = nil;
    self.assetReader = nil;
    self.assetWriter = nil;
    self.assetReaderAudioOutput = nil;
    self.assetWriterAudioInput = nil;
    self.assetReaderVideoOutput = nil;
    self.assetWriterVideoInput = nil;
    
    self.dispatchGroup = NULL;
    self.mainSerializationQueue = NULL;
    self.rwAudioSerializationQueue = NULL;
    self.rwVideoSerializationQueue = NULL;
}

// 参阅 http://www.devzhang.cn/2016/09/20/Asset的重编码及导出/
- (void)compreessVideoWithInputURL:(NSURL*)inputURL
                         outputURL:(NSURL*)outputURL
                          duration:(CGFloat)duration
                         comletion:(void (^)(void))completion {
    
    self.inputURL = inputURL;
    self.outputURL = outputURL;
    self.completion = completion;
    
    BOOL optimzeFlag = true;
//    NSString *modalName = [[UIDevice currentDevice] machineModel];
//    if ([modalName hasPrefix:@"iPhone"]) {
//        // 大于iPhone12的机型不根据时长优化，采用一致压缩策略
//        if ([modalName compare:@"iPhone12,8"] == NSOrderedDescending) {
//            optimzeFlag = false;
//        }
//    }
    // 超过1分钟的视频压缩算法降级，时间更快，大小更低，但质量较低
    if (optimzeFlag && duration > 60) {
        [self reSimpleEncoding:AVAssetExportPresetMediumQuality];
        return;
    }
    [self reComplexEncoding];
}

- (void)callComplete {
    
    self.compressSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.outputURL.path error:nil] fileSize];
//    NSLog(@"###: after size %llu", self.compressSize);
//    NSLog(@"###: cost time: %f", CFAbsoluteTimeGetCurrent() - self.startTime);
    // 目前是用来压缩视频，但是有些视频压缩出来反而更大（原视频格式、帧率等等、及压缩输出格式各项设置等原因导致）
    if (self.originSize > 0 && self.compressSize > 0) {
        if (self.compressSize > self.originSize) {
            [[NSFileManager defaultManager] removeItemAtPath:self.outputURL.path error:nil];
            [self reSimpleEncoding:AVAssetExportPresetPassthrough];
            return;
        }
    }
    
    if (self.completion) {
        self.completion();
    }
}

- (void)reSimpleEncoding:(NSString *)presetName {

    self.startTime = CFAbsoluteTimeGetCurrent();
    if (self.mainSerializationQueue == NULL) {
        NSString *serializationQueueDescription = [NSString stringWithFormat:@"com.videoEncoding.queue.%@", self];
        self.mainSerializationQueue = dispatch_queue_create([serializationQueueDescription UTF8String], NULL);
    }
    dispatch_async(self.mainSerializationQueue, ^{
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:self.inputURL options:nil];
        self.originSize = urlAsset.fileSize;
//        NSLog(@"###: before size %llu", self.originSize);
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:urlAsset presetName:presetName];
        exportSession.outputURL = self.outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            self.compressSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.outputURL.path error:nil] fileSize];
//            NSLog(@"###: after size %llu", self.compressSize);
//            NSLog(@"###: cost time: %f", CFAbsoluteTimeGetCurrent() - self.startTime);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.completion) {
                    self.completion();
                }
            });
        }];
    });
}

- (void)reComplexEncoding {
    
    self.startTime = CFAbsoluteTimeGetCurrent();
    // Create the main serialization queue.
    NSString *serializationQueueDescription = [NSString stringWithFormat:@"com.videoEncoding.queue.%@", self];
    self.mainSerializationQueue = dispatch_queue_create([serializationQueueDescription UTF8String], NULL);
    
    self.asset = [[AVURLAsset alloc] initWithURL:self.inputURL options:nil];
    self.originSize = ((AVURLAsset *)self.asset).fileSize;
//    NSLog(@"###: before size %llu", self.originSize);
    [self.asset loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        dispatch_async(self.mainSerializationQueue, ^{
            if (self.cancelled) {
                [self callComplete];
                return;
            }
                           
            BOOL success = YES;
            NSError *localError = nil;
            // Check for success of loading the assets tracks.
            success = ([self.asset statusOfValueForKey:@"tracks" error:&localError] == AVKeyValueStatusLoaded);
            if (success)
            {
                // If the tracks loaded successfully, make sure that no file exists at the output path for the asset writer.
                NSFileManager *fm = [NSFileManager defaultManager];
                NSString *localOutputPath = [self.outputURL path];
                if ([fm fileExistsAtPath:localOutputPath])
                    success = [fm removeItemAtPath:localOutputPath error:&localError];
            }
            if (success)
                success = [self setupAssetReaderAndAssetWriter:&localError];
            if (success)
                success = [self startAssetReaderAndWriter:&localError];
            if (!success)
                [self readingAndWritingDidFinishSuccessfully:success withError:localError];
        });
    }];
}

- (BOOL)setupAssetReaderAndAssetWriter:(NSError **)outError {

    // Create and initialize the asset reader.
    self.assetReader = [[AVAssetReader alloc] initWithAsset:self.asset error:outError];
    BOOL success = (self.assetReader != nil);
    if (success)
    {
         // If the asset reader was successfully initialized, do the same for the asset writer.
         self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.outputURL fileType:AVFileTypeMPEG4 error:outError];
         success = (self.assetWriter != nil);
    }

    if (success)
    {
         // If the reader and writer were successfully initialized, grab the audio and video asset tracks that will be used.
         AVAssetTrack *assetAudioTrack = nil, *assetVideoTrack = nil;
         NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
         if ([audioTracks count] > 0)
              assetAudioTrack = [audioTracks objectAtIndex:0];
         NSArray *videoTracks = [self.asset tracksWithMediaType:AVMediaTypeVideo];
         if ([videoTracks count] > 0)
              assetVideoTrack = [videoTracks objectAtIndex:0];

         if (assetAudioTrack)
         {
              // If there is an audio track to read, set the decompression settings to Linear PCM and create the asset reader output.
//             [HHVideoCompreeeTools audioOutputSettings]
              self.assetReaderAudioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:assetAudioTrack outputSettings:[HHVideoCompreeeTools audioOutputSettings]];
              [self.assetReader addOutput:self.assetReaderAudioOutput];
//             [HHVideoCompreeeTools audioInputSettings];
              self.assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:[assetAudioTrack mediaType] outputSettings:[HHVideoCompreeeTools audioInputSettings]];
             self.assetWriterAudioInput.expectsMediaDataInRealTime = true;
              [self.assetWriter addInput:self.assetWriterAudioInput];
         }

         if (assetVideoTrack)
         {
              // If there is a video track to read, set the decompression settings for YUV and create the asset reader output.
              self.assetReaderVideoOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:assetVideoTrack outputSettings:[HHVideoCompreeeTools videoOutputSettings]];
              [self.assetReader addOutput:self.assetReaderVideoOutput];

              // Create the asset writer input and add it to the asset writer.
              self.assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:[assetVideoTrack mediaType] outputSettings:[HHVideoCompreeeTools videoInputSettings:assetVideoTrack]];
             self.assetWriterVideoInput.expectsMediaDataInRealTime = true;
             self.assetWriterVideoInput.transform = assetVideoTrack.preferredTransform;
              [self.assetWriter addInput:self.assetWriterVideoInput];
         }
    }
    return success;
}

- (BOOL)startAssetReaderAndWriter:(NSError **)outError {
    
    BOOL success = YES;
    // Attempt to start the asset reader.
    success = [self.assetReader startReading];
    if (!success)
        *outError = [self.assetReader error];
    if (success)
    {
        // If the reader started successfully, attempt to start the asset writer.
        success = [self.assetWriter startWriting];
        if (!success)
            *outError = [self.assetWriter error];
    }
    
    if (success)
    {
        // If the asset reader and writer both started successfully, create the dispatch group where the reencoding will take place and start a sample-writing session.
        self.dispatchGroup = dispatch_group_create();
        [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
        self.audioFinished = NO;
        self.videoFinished = NO;
        
        if (self.assetWriterVideoInput)
        {
            // If we had video to reencode, enter the dispatch group before beginning the work.
            dispatch_group_enter(self.dispatchGroup);
            NSString *rwVideoSerializationQueueDescription = [NSString stringWithFormat:@"com.videoEncoding.video.queue.%@", self];
            self.rwVideoSerializationQueue = dispatch_queue_create([rwVideoSerializationQueueDescription UTF8String], NULL);
            // Specify the block to execute when the asset writer is ready for video media data, and specify the queue to call it on.
            [self.assetWriterVideoInput requestMediaDataWhenReadyOnQueue:self.rwVideoSerializationQueue usingBlock:^{
                // Because the block is called asynchronously, check to see whether its task is complete.
                if (self.videoFinished) {
                    return;
                }
                BOOL completedOrFailed = NO;
                // If the task isn't complete yet, make sure that the input is actually ready for more media data.
                while ([self.assetWriterVideoInput isReadyForMoreMediaData] && !completedOrFailed)
                {
                    // Get the next video sample buffer, and append it to the output file.
                    CMSampleBufferRef sampleBuffer = [self.assetReaderVideoOutput copyNextSampleBuffer];
                    if (sampleBuffer != NULL)
                    {
                        BOOL success = [self.assetWriterVideoInput appendSampleBuffer:sampleBuffer];
//                        if (!success) {
//                            if (self.assetWriter.status == AVAssetWriterStatusFailed) {
//                                NSLog(@"###: video error: %@", self.assetWriter.error);
//                            }
//                        }
                        CFRelease(sampleBuffer);
                        sampleBuffer = NULL;
                        completedOrFailed = !success;
                    }
                    else
                    {
                        completedOrFailed = YES;
                    }
                }
                if (completedOrFailed)
                {
                    // Mark the input as finished, but only if we haven't already done so, and then leave the dispatch group (since the video work has finished).
                    BOOL oldFinished = self.videoFinished;
                    self.videoFinished = YES;
                    if (oldFinished == NO)
                    {
                        [self.assetWriterVideoInput markAsFinished];
                    }
                    dispatch_group_leave(self.dispatchGroup);
                }
            }];
        }
        
        if (self.assetWriterAudioInput)
        {
            // If there is audio to reencode, enter the dispatch group before beginning the work.
            dispatch_group_enter(self.dispatchGroup);
            NSString *rwAudioSerializationQueueDescription = [NSString stringWithFormat:@"com.videoEncoding.audio.queue.%@", self];
            self.rwAudioSerializationQueue = dispatch_queue_create([rwAudioSerializationQueueDescription UTF8String], NULL);
            // Specify the block to execute when the asset writer is ready for audio media data, and specify the queue to call it on.
            [self.assetWriterAudioInput requestMediaDataWhenReadyOnQueue:self.rwAudioSerializationQueue usingBlock:^{
                // Because the block is called asynchronously, check to see whether its task is complete.
                if (self.audioFinished) {
                    return;
                }
                
                BOOL completedOrFailed = NO;
                // If the task isn't complete yet, make sure that the input is actually ready for more media data.
                while ([self.assetWriterAudioInput isReadyForMoreMediaData] && !completedOrFailed)
                {
                    // Get the next audio sample buffer, and append it to the output file.
                    CMSampleBufferRef sampleBuffer = [self.assetReaderAudioOutput copyNextSampleBuffer];
                    if (sampleBuffer != NULL)
                    {
                        BOOL success = [self.assetWriterAudioInput appendSampleBuffer:sampleBuffer];
//                        if (!success) {
//                            if (self.assetWriter.status == AVAssetWriterStatusFailed) {
//                                NSLog(@"###: auido error: %@", self.assetWriter.error);
//                            }
//                        }
                        CFRelease(sampleBuffer);
                        sampleBuffer = NULL;
                        completedOrFailed = !success;
                    }
                    else
                    {
                        completedOrFailed = YES;
                    }
                }
                if (completedOrFailed)
                {
                    // Mark the input as finished, but only if we haven't already done so, and then leave the dispatch group (since the audio work has finished).
                    BOOL oldFinished = self.audioFinished;
                    self.audioFinished = YES;
                    if (oldFinished == NO)
                    {
                        [self.assetWriterAudioInput markAsFinished];
                    }
                    dispatch_group_leave(self.dispatchGroup);
                }
            }];
        }
        
        // Set up the notification that the dispatch group will send when the audio and video work have both finished.
        dispatch_group_notify(self.dispatchGroup, self.mainSerializationQueue, ^{
            BOOL finalSuccess = YES;
            NSError *finalError = nil;
            // Check to see if the work has finished due to cancellation.
            if (self.cancelled)
            {
                // If so, cancel the reader and writer.
                [self.assetReader cancelReading];
                [self.assetWriter cancelWriting];
            }
            else
            {
                // If cancellation didn't occur, first make sure that the asset reader didn't fail.
                if ([self.assetReader status] == AVAssetReaderStatusFailed)
                {
                    finalSuccess = NO;
                    finalError = [self.assetReader error];
                }
                // If the asset reader didn't fail, attempt to stop the asset writer and check for any errors.
                if (finalSuccess)
                {
                    finalSuccess = [self.assetWriter finishWriting];
                    if (!finalSuccess) {
                        finalError = [self.assetWriter error];
                    }
                }
            }
            // Call the method to handle completion, and pass in the appropriate parameters to indicate whether reencoding was successful.
            [self readingAndWritingDidFinishSuccessfully:finalSuccess withError:finalError];
        });
    }
    // Return success here to indicate whether the asset reader and writer were started successfully.
    return success;
}

- (void)readingAndWritingDidFinishSuccessfully:(BOOL)success withError:(NSError *)error {
    
    if (!success)
    {
        // If the reencoding process failed, we need to cancel the asset reader and writer.
        [self.assetReader cancelReading];
        [self.assetWriter cancelWriting];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Handle any UI tasks here related to failure.
            [self callComplete];
        });
    }
    else
    {
        // Reencoding was successful, reset booleans.
        self.cancelled = NO;
        self.videoFinished = NO;
        self.audioFinished = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Handle any UI tasks here related to success.
            [self callComplete];
        });
    }
}

- (void)cancel {
    
    // Handle cancellation asynchronously, but serialize it with the main queue.
    dispatch_async(self.mainSerializationQueue, ^{
        // If we had audio data to reencode, we need to cancel the audio work.
        if (self.assetWriterAudioInput)
        {
            // Handle cancellation asynchronously again, but this time serialize it with the audio queue.
            dispatch_async(self.rwAudioSerializationQueue, ^{
                // Update the Boolean property indicating the task is complete and mark the input as finished if it hasn't already been marked as such.
                BOOL oldFinished = self.audioFinished;
                self.audioFinished = YES;
                if (oldFinished == NO)
                {
                    [self.assetWriterAudioInput markAsFinished];
                }
                // Leave the dispatch group since the audio work is finished now.
                dispatch_group_leave(self.dispatchGroup);
            });
        }
        
        if (self.assetWriterVideoInput)
        {
            // Handle cancellation asynchronously again, but this time serialize it with the video queue.
            dispatch_async(self.rwVideoSerializationQueue, ^{
                // Update the Boolean property indicating the task is complete and mark the input as finished if it hasn't already been marked as such.
                BOOL oldFinished = self.videoFinished;
                self.videoFinished = YES;
                if (oldFinished == NO)
                {
                    [self.assetWriterVideoInput markAsFinished];
                }
                // Leave the dispatch group, since the video work is finished now.
                dispatch_group_leave(self.dispatchGroup);
            });
        }
        // Set the cancelled Boolean property to YES to cancel any work on the main queue as well.
        self.cancelled = YES;
    });
}


/*
    音视频压缩效果调下述参数，上述流程不易轻动！！
 */

+ (NSDictionary *)audioInputSettings {
    
    NSDictionary *compressionAudioSettings = @{ AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                                AVNumberOfChannelsKey: @2,
                                                AVSampleRateKey: @44100,
                                                AVEncoderBitRateKey: @128000,
    };
    return compressionAudioSettings;
    
    // Then, set the compression settings to 128kbps AAC and create the asset writer input.
//    AudioChannelLayout stereoChannelLayout = {
//        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
//        .mChannelBitmap = 0,
//        .mNumberChannelDescriptions = 0
//    };
//    NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
//    NSDictionary *compressionAudioSettings = @{
//        AVFormatIDKey         : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
//        AVEncoderBitRateKey   : [NSNumber numberWithInteger:128000],
//        AVSampleRateKey       : [NSNumber numberWithInteger:44100],
//        AVChannelLayoutKey    : channelLayoutAsData,
//        AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:2]
//    };
//    return compressionAudioSettings;
}

+ (NSDictionary *)audioOutputSettings {
    
    NSDictionary *decompressionAudioSettings = @{AVFormatIDKey : [NSNumber numberWithUnsignedInt:kAudioFormatLinearPCM] };
    return decompressionAudioSettings;
    
}

+ (NSDictionary *)videoOutputSettings {
    
    NSDictionary *decompressionVideoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]};
    return decompressionVideoSettings;
    
//    NSDictionary *decompressionVideoSettings = @{
//        (id)kCVPixelBufferPixelFormatTypeKey     : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_422YpCbCr8],
//        (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary]
//    };
//    return decompressionVideoSettings;
}

+ (NSDictionary *)videoInputSettings:(AVAssetTrack *)assetVideoTrack {

    CGSize videoSize = assetVideoTrack.naturalSize;
    NSDictionary *videoWriterCompressionSettings = @{AVVideoAverageBitRateKey: [NSNumber numberWithInt:1250000]};
    
    NSDictionary *videoWriterSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                          AVVideoCompressionPropertiesKey: videoWriterCompressionSettings,
                                          AVVideoWidthKey: [NSNumber numberWithFloat:videoSize.width],
                                          AVVideoHeightKey:[NSNumber numberWithFloat:videoSize.height]};
    return videoWriterSettings;
    
//    CMFormatDescriptionRef formatDescription = NULL;
//    // Grab the video format descriptions from the video track and grab the first one if it exists.
//    NSArray *videoFormatDescriptions = [assetVideoTrack formatDescriptions];
//    if ([videoFormatDescriptions count] > 0)
//        formatDescription = (__bridge CMFormatDescriptionRef)[videoFormatDescriptions objectAtIndex:0];
//    CGSize trackDimensions = {
//        .width = 0.0,
//        .height = 0.0,
//    };
//    // If the video track had a format description, grab the track dimensions from there. Otherwise, grab them direcly from the track itself.
//    if (formatDescription)
//        trackDimensions = CMVideoFormatDescriptionGetPresentationDimensions(formatDescription, false, false);
//    else
//        trackDimensions = [assetVideoTrack naturalSize];
//    NSDictionary *compressionSettings = nil;
//    // If the video track had a format description, attempt to grab the clean aperture settings and pixel aspect ratio used by the video.
//    if (formatDescription)
//    {
//        NSDictionary *cleanAperture = nil;
//        NSDictionary *pixelAspectRatio = nil;
//        CFDictionaryRef cleanApertureFromCMFormatDescription = CMFormatDescriptionGetExtension(formatDescription, kCMFormatDescriptionExtension_CleanAperture);
//        if (cleanApertureFromCMFormatDescription)
//        {
//            cleanAperture = @{
//                AVVideoCleanApertureWidthKey            : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureWidth),
//                AVVideoCleanApertureHeightKey           : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureHeight),
//                AVVideoCleanApertureHorizontalOffsetKey : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureHorizontalOffset),
//                AVVideoCleanApertureVerticalOffsetKey   : (id)CFDictionaryGetValue(cleanApertureFromCMFormatDescription, kCMFormatDescriptionKey_CleanApertureVerticalOffset)
//            };
//        }
//        CFDictionaryRef pixelAspectRatioFromCMFormatDescription = CMFormatDescriptionGetExtension(formatDescription, kCMFormatDescriptionExtension_PixelAspectRatio);
//        if (pixelAspectRatioFromCMFormatDescription)
//        {
//            pixelAspectRatio = @{
//                AVVideoPixelAspectRatioHorizontalSpacingKey : (id)CFDictionaryGetValue(pixelAspectRatioFromCMFormatDescription, kCMFormatDescriptionKey_PixelAspectRatioHorizontalSpacing),
//                AVVideoPixelAspectRatioVerticalSpacingKey   : (id)CFDictionaryGetValue(pixelAspectRatioFromCMFormatDescription, kCMFormatDescriptionKey_PixelAspectRatioVerticalSpacing)
//            };
//        }
//        // Add whichever settings we could grab from the format description to the compression settings dictionary.
//        if (cleanAperture || pixelAspectRatio)
//        {
//            NSMutableDictionary *mutableCompressionSettings = [NSMutableDictionary dictionary];
//            if (cleanAperture)
//                [mutableCompressionSettings setObject:cleanAperture forKey:AVVideoCleanApertureKey];
//            if (pixelAspectRatio)
//                [mutableCompressionSettings setObject:pixelAspectRatio forKey:AVVideoPixelAspectRatioKey];
//            compressionSettings = mutableCompressionSettings;
//        }
//    }
//    // Create the video settings dictionary for H.264.
//    NSMutableDictionary *videoSettings = (NSMutableDictionary *) @{
//        AVVideoCodecKey  : AVVideoCodecH264,
//        AVVideoWidthKey  : [NSNumber numberWithDouble:trackDimensions.width],
//        AVVideoHeightKey : [NSNumber numberWithDouble:trackDimensions.height]
//    };
//    // Put the compression settings into the video settings dictionary if we were able to grab them.
//    if (compressionSettings) {
//        [videoSettings setObject:compressionSettings forKey:AVVideoCompressionPropertiesKey];
//    }
//    return videoSettings;
}


@end
