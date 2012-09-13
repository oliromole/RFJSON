/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:

   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   Neither the name of the the author nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SBJsonStreamParserState.h"
#import "SBJsonStreamParser.h"

@implementation SBJsonStreamParserState

+ (id)sharedInstance { return nil; }

- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return NO;
}

- (SBJsonStreamParserStatus)parserShouldReturn:(SBJsonStreamParser*)parser {
	return SBJsonStreamParserWaitingForData;
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {}

- (BOOL)needKey {
	return NO;
}

- (NSString*)name {
	return @"<aaiie!>";
}

- (BOOL)isError {
    return NO;
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateStart

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return token == sbjson_token_array_start || token == sbjson_token_object_start;
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {

	SBJsonStreamParserState *state = nil;
	switch (tok) {
		case sbjson_token_array_start:
			state = [SBJsonStreamParserStateArrayStart sharedInstance];
			break;

		case sbjson_token_object_start:
			state = [SBJsonStreamParserStateObjectStart sharedInstance];
			break;

		case sbjson_token_array_end:
		case sbjson_token_object_end:
			if (parser.supportMultipleDocuments)
				state = parser.state;
			else
				state = [SBJsonStreamParserStateComplete sharedInstance];
			break;

		case sbjson_token_eof:
			return;

		default:
			state = [SBJsonStreamParserStateError sharedInstance];
			break;
	}


	parser.state = state;
}

- (NSString*)name { return @"before outer-most array or object"; }

@end

#pragma mark -

@implementation SBJsonStreamParserStateComplete

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"after outer-most array or object"; }

- (SBJsonStreamParserStatus)parserShouldReturn:(SBJsonStreamParser*)parser {
	return SBJsonStreamParserComplete;
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateError

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"in error"; }

- (SBJsonStreamParserStatus)parserShouldReturn:(SBJsonStreamParser*)parser {
	return SBJsonStreamParserError;
}

- (BOOL)isError {
    return YES;
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateObjectStart

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"at beginning of object"; }

- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_end:
		case sbjson_token_string:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.state = [SBJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateObjectGotKey

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}

- (NSString*)name { return @"after object key"; }

- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return token == sbjson_token_keyval_separator;
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.state = [SBJsonStreamParserStateObjectSeparator sharedInstance];
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateObjectSeparator

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"as object value"; }

- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_start:
		case sbjson_token_array_start:
		case sbjson_token_true:
		case sbjson_token_false:
		case sbjson_token_null:
		case sbjson_token_number:
		case sbjson_token_string:
			return YES;
			break;

		default:
			return NO;
			break;
	}
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.state = [SBJsonStreamParserStateObjectGotValue sharedInstance];
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateObjectGotValue

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"after object value"; }

- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_end:
		case sbjson_token_separator:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.state = [SBJsonStreamParserStateObjectNeedKey sharedInstance];
}


@end

#pragma mark -

@implementation SBJsonStreamParserStateObjectNeedKey

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"in place of object key"; }

- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
    return sbjson_token_string == token;
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.state = [SBJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateArrayStart

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"at array start"; }

- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_object_end:
		case sbjson_token_keyval_separator:
		case sbjson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.state = [SBJsonStreamParserStateArrayGotValue sharedInstance];
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateArrayGotValue

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"after array value"; }


- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	return token == sbjson_token_array_end || token == sbjson_token_separator;
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	if (tok == sbjson_token_separator)
		parser.state = [SBJsonStreamParserStateArrayNeedValue sharedInstance];
}

@end

#pragma mark -

@implementation SBJsonStreamParserStateArrayNeedValue

+ (id)sharedInstance {
    static id state = nil;
    if (!state) {
        @synchronized(self) {
            if (!state) state = [[self alloc] init];
        }
    }
    return state;
}


- (NSString*)name { return @"as array value"; }


- (BOOL)parser:(SBJsonStreamParser*)parser shouldAcceptToken:(sbjson_token_t)token {
	switch (token) {
		case sbjson_token_array_end:
		case sbjson_token_keyval_separator:
		case sbjson_token_object_end:
		case sbjson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(SBJsonStreamParser*)parser shouldTransitionTo:(sbjson_token_t)tok {
	parser.state = [SBJsonStreamParserStateArrayGotValue sharedInstance];
}

@end
