"
Represents a specific output of an operation.
"
Class {
	#name : #TFOutput,
	#superclass : #TFStructure,
	#instVars : [
		'graph'
	],
	#classVars : [
		'OFFSET_INDEX',
		'OFFSET_OPERATION'
	],
	#category : #TensorFlowCore
}

{ #category : #'field definition' }
TFOutput class >> asExternalTypeOn: aFFICallout [ 
	^ FFIExternalStructureType objectClass: self
]

{ #category : #'field definition' }
TFOutput class >> fieldsDesc [
	"self rebuildFieldAccessors"

	"// Represents a specific output of an operation.
typedef struct TF_Output {
  TF_Operation* oper;
  int index;  // The index of the output within oper.
} TF_Output;"

	^ #(
		#TFOperation * operation ;
		int index)
]

{ #category : #'instance creation' }
TFOutput class >> onOperation: aTF_Operation index: anInteger [

	^ self externalNew
		operation: aTF_Operation getHandle;
		index: anInteger;
		graph: aTF_Operation graph;
		yourself
]

{ #category : #accessing }
TFOutput >> graph [

	^graph
]

{ #category : #accessing }
TFOutput >> graph: aTFGraph [

	graph := aTFGraph
]

{ #category : #'accessing structure variables' }
TFOutput >> index [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_INDEX
]

{ #category : #'accessing structure variables' }
TFOutput >> index: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_INDEX put: anObject
]

{ #category : #'accessing structure variables' }
TFOutput >> operation [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_OPERATION) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
TFOutput >> operation: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_OPERATION put: anObject getHandle.
]

{ #category : #accessing }
TFOutput >> operationOn: aTF_Graph [
	| answer |
	answer := TFOperation fromHandle: (handle longPointerAt: 1).
	answer graph: aTF_Graph.
	^ answer
]

{ #category : #printing }
TFOutput >> printOn: aStream [
	super printOn: aStream.
"	aStream
		space;
		print: (TF_DataTypeEnum itemAt: self type)"
]

{ #category : #'private - accessing' }
TFOutput >> tensorflowTypeFrom: aProtobufferType [

	| mapping |

	"Ref: https://github.com/tensorflow/tensorflow/blob/master/tensorflow/core/framework/types.proto"
	mapping := Dictionary new
		at: 101 put: TFTensor typeFloat;
		at: 102 put: TFTensor typeFloat;
		at: 103 put: TFTensor typeInt32;
		yourself.

	^ mapping
		at: aProtobufferType
		ifAbsent: [ self
				error: ( 'No mapping found for the Protobuffer data type <1s>' expandMacrosWith: aProtobufferType )
			]
]

{ #category : #accessing }
TFOutput >> type [

	| type |

	type := self library operationOutputType: self.	
	" When querying the type of a Variable node output, TF_OperationOutputType is
	 returning the protobuf DataType enum 
	Ref: https://github.com/tensorflow/tensorflow/issues/5409. "

	^ ( TFOperation fromHandle: self operation ) type = 'Variable'
		ifTrue: [ self tensorflowTypeFrom: type ]
		ifFalse: [ type ]
]

{ #category : #accessing }
TFOutput >> withNormalizedHandle [
	" This still needs work, but sometime an output comes with a 
	handle FFIExternalStructureReferenceHandle and so I convert 
	them to one having an ExternalAddress instead "
	^ self getHandle class = FFIExternalStructureReferenceHandle
		ifTrue: [ TFOutput fromHandle: self getHandle asExternalAddress ]
		ifFalse: [ self ]
]
