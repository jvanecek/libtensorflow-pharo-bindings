"
TF_Buffer holds a pointer to a block of data and its associated length.
Typically, the data consists of a serialized protocol buffer, but other data may also be held in a buffer.
"
Class {
	#name : #TFBuffer,
	#superclass : #TFStructure,
	#classVars : [
		'OFFSET_DATA',
		'OFFSET_DEALLOCATOR',
		'OFFSET_LENGTH'
	],
	#category : #'TensorFlowCore-Structures'
}

{ #category : #'field definition' }
TFBuffer class >> fieldsDesc [
	"self rebuildFieldAccessors"
	
	"typedef struct TF_Buffer {
  		const void* data;
  		size_t length;
  		void (*data_deallocator)(void* data, size_t length);
		} TF_Buffer;"
	^#(
	void * data;
	size_t length;
	void * deallocator;
	)
]

{ #category : #'instance creation' }
TFBuffer class >> fromFileNamed: aString [
	| fileContents |
	fileContents := aString asFileReference readStream contents.
	^ self fromString: fileContents
]

{ #category : #'instance creation' }
TFBuffer class >> fromString: aString [

	^ TensorFlowCAPI current newBufferFromString: aString
]

{ #category : #'instance creation' }
TFBuffer class >> newFromFileNamed: aString deleteAfter: aBlock [

	| buffer |

	buffer := self fromFileNamed: aString.
	[ aBlock value: buffer ] ensure: [ buffer delete ]
]

{ #category : #'instance creation' }
TFBuffer class >> newWith: aString deleteAfter: aBlock [

	| buffer |

	buffer := self fromString: aString.
	[ aBlock value: buffer ] ensure: [ buffer delete ]
]

{ #category : #'accessing structure variables' }
TFBuffer >> data [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
TFBuffer >> data: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA put: anObject getHandle.
]

{ #category : #accessing }
TFBuffer >> dataBytes [
	^ self data getHandle structAt: 1 length: self length
]

{ #category : #'accessing structure variables' }
TFBuffer >> deallocator [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DEALLOCATOR) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
TFBuffer >> deallocator: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DEALLOCATOR put: anObject getHandle.
]

{ #category : #release }
TFBuffer >> delete [
	self isNull
		ifFalse: [ self library deleteBuffer: self ].
	handle := nil
]

{ #category : #'accessing structure variables' }
TFBuffer >> length [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_LENGTH
]

{ #category : #'accessing structure variables' }
TFBuffer >> length: anObject [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_LENGTH put: anObject
]
