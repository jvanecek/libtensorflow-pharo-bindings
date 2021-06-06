Class {
	#name : #TFSessionOptions,
	#superclass : #FFIOpaqueObject,
	#category : #TensorFlowCore
}

{ #category : #'instance creation' }
TFSessionOptions class >> create [
	^ TensorFlowCAPI current newAutoreleaseSessionOptions
]

{ #category : #'instance creation' }
TFSessionOptions class >> finalizeResourceData: handle [

	handle isNull ifTrue: [ ^ self ].
	TensorFlowCAPI current deleteSessionOptions: handle
]

{ #category : #'instance creation' }
TFSessionOptions class >> fromProtoBuf: aString [
	| answer |
	answer := self create.
	answer config: aString.
	^ answer
]

{ #category : #'instance creation' }
TFSessionOptions class >> onTarget: aString [
	^ self create target: aString
]

{ #category : #'initialize-release' }
TFSessionOptions >> config: aByteObject [
	"Set the config in TF_SessionOptions.options.
	 config should be a serialized tensorflow.ConfigProto proto.
	 If config was not parsed successfully as a ConfigProto, record the
	 error information in *status.
	 
	 Arguments:
		aByteObject - <String | ByteArray>
	 Answers:
		<TFStatus>"

	self library sessionOptions: self setConfig: aByteObject
]

{ #category : #'initialize-release' }
TFSessionOptions >> library [
	^ TensorFlowCAPI current
]

{ #category : #'initialize-release' }
TFSessionOptions >> target: aString [
	" 'local' 'google.com:1234' '192.168.1.1:1234' 'local,example.com:1234' etc.
	are all valid target strings"
	self library sessionOptions: self setTarget: aString.

]
