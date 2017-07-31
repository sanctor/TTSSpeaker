//
//  ViewController.m
//  Speaker
//
//  Created by Serge Golubenko on 26.07.17.
//  Copyright © 2017 sanctor. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVSpeechSynthesizerDelegate>
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@property (strong, nonatomic) NSArray<NSString *> *sentences;

@property (nonatomic, assign) NSUInteger nextSpeechIndex;
@property (nonatomic, assign) NSUInteger currentSpeechIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sentences = @[@"Do you want to continue to read this document?", @"Möchten Sie mit dem Lesen dieser Datei fortfahren?", @"Продолжить чтение?", @"Продовжити читання?", @"Voulez-vous continuer à le lire ?", @"Você quer continuar a ler este documento?", @"Bu belgeyi okumaya devam etmek istiyor musunuz?", @"A bheil thu airson leantainn air adhart sgrìobhainn seo a leughadh?", @"Ցանկանում եք շարունակել կարդալ այս փաստաթուղթը:", @"क्या आप इस दस्तावेज़ को पढ़ना जारी रखना चाहते हैं?", @"هل تريد متابعة قراءة هذا المستند؟", @"האם ברצונך להמשיך לקרוא מסמך זה?", @"Vuoi continuare a leggere questo documento?", @"你想繼續閱讀本文檔嗎", @"この文書を引き続き読んでみませんか"];
    
    self.currentSpeechIndex = 0;
    self.nextSpeechIndex = 0;
    
    [self startSpeaking];
}

- (void)setupForCurrentPage {
    self.lblSentence.text = self.sentences[self.currentSpeechIndex];
    self.nextSpeechIndex = self.currentSpeechIndex + 1;
    if (self.nextSpeechIndex >= self.sentences.count) {
        self.nextSpeechIndex = 0;
    }
}

- (void)startSpeaking {
    if (!self.synthesizer) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.synthesizer.delegate = self;
    }
    
    [self speakNextUtterance];
}

- (void)speakNextUtterance {
    if (self.nextSpeechIndex < self.sentences.count) {
        self.currentSpeechIndex = self.nextSpeechIndex;
        [self setupForCurrentPage];
        
        NSString *sentence = self.sentences[self.currentSpeechIndex];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:sentence];
//        utterance.rate = 0.8;
        
        NSString *isoLangCode = (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)sentence, CFRangeMake(0, sentence.length)));
        
        if (isoLangCode.length) {
            AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:isoLangCode];
            if (voice) {
                NSLog(@"Voice: %@ - %@", voice.name, voice.language);
                self.lblLanguage.text = [NSString stringWithFormat:@"%@ : %@", isoLangCode, voice.language];
                self.lblVoice.text = voice.name;
                utterance.voice = voice;
            } else {
                self.lblLanguage.text = isoLangCode;
                self.lblVoice.text = @"No voice";
            }
        }
        
        [self.synthesizer speakUtterance:utterance];
    }
}

#pragma mark - AVSpeechSynthesizerDelegate Protocol

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance {
    [self speakNextUtterance];
}

@end
