"
TF_Status holds error information.  It either has an OK code, or else an error code with an associated error message.
"
Class {
	#name : #TFStatus,
	#superclass : #FFIOpaqueObject,
	#category : #TensorFlowCore
}

{ #category : #'instance creation' }
TFStatus class >> create [
	^ TensorFlowCAPI current newAutoreleaseStatus
]

{ #category : #'finalize resources' }
TFStatus class >> finalizeResourceData: handle [

	handle isNull ifTrue: [ ^ self ].
	(TensorFlowCAPI current) deleteStatus: handle
]

{ #category : #testing }
TFStatus >> check [
	self isOk
		ifFalse: [ Error signal: self codeText , ': ' , self message ]
]

{ #category : #accessing }
TFStatus >> code [

	^self library getCodeOf: self
]

{ #category : #accessing }
TFStatus >> code: aTFCode message: aString [

	self assert: aTFCode ~= 0.
	self library setStatus: self code: aTFCode message: aString
]

{ #category : #accessing }
TFStatus >> codeText [
	^ self codeTexts at: self code + 1
]

{ #category : #accessing }
TFStatus >> codeTexts [
	"self new codeTexts"
	^ #(  
	'OK' "0"
	'CANCELLED' "1"
	'UNKNOWN' "2"
	'INVALID_ARGUMENT' "3"
	'DEADLINE_EXCEEDED' "4"
	'NOT_FOUND' "5"
	'ALREADY_EXISTS' "6"
	'PERMISSION_DENIED' "7"
	'RESOURCE_EXHAUSTED' "8"
	'FAILED_PRECONDITION' "9"
	'ABORTED' "10"
	'OUT_OF_RANGE' "11"
	'UNIMPLEMENTED' "12"
	'INTERNALt' "13"
	'UNAVAILABLE' "14"
	'DATA_LOSS' "15"
	'UNAUTHENTICATED' "16"
)
]

{ #category : #testing }
TFStatus >> isOk [
	^ self code == 0
]

{ #category : #private }
TFStatus >> library [
	^ TensorFlowCAPI current
]

{ #category : #accessing }
TFStatus >> message [
	^ self library message: self
]

{ #category : #printing }
TFStatus >> printOn: stream [
	super printOn: stream.
	self isNull
		ifFalse: [ stream
				space;
				print: self codeText;
				space;
				print: self message ]
]
