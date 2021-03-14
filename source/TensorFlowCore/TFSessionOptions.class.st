Class {
	#name : #TFSessionOptions,
	#superclass : #FFIOpaqueObject,
	#category : #TensorFlowCore
}

{ #category : #'instance creation' }
TFSessionOptions class >> create [
	^ TensorFlowCAPI current newSessionOptions autoRelease
]

{ #category : #'instance creation' }
TFSessionOptions class >> finalizeResourceData: handle [

	handle isNull ifTrue: [ ^ self ].
	(TensorFlowCAPI current) deleteSessionOptions: handle
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
TFSessionOptions >> config: aString [
	| status |
	status := TFStatus create.
	self library sessionOptions: self setConfig: aString configSize: aString size status: status.
	status check
]

{ #category : #'initialize-release' }
TFSessionOptions >> delete [
"deprecated"
self halt.

	self ignoreFinalization.
	self isNull ifFalse: [
		self library deleteSessionOptions: self].
	handle := nil
]

{ #category : #'initialize-release' }
TFSessionOptions >> library [
	^ TensorFlowCAPI current
]

{ #category : #'initialize-release' }
TFSessionOptions >> target: aString [
	" 'local' 'google.com:1234' '192.168.1.1:1234' 'local,example.com:1234' etc.
	are all valid target strings"
	self library sessionOptions: self setTarget: (self library externalizeString: aString).

]
