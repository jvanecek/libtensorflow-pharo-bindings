Extension { #name : #TFTensor }

{ #category : #'*TFOperationModel' }
TFTensor class >> descriptionOf: aType [

	^ Dictionary new
		at: TFDataTypeEnum tfBfloat16 value put: 'BFloat16';
		at: TFDataTypeEnum tfBool value put: 'Bool';
		at: TFDataTypeEnum tfComplex value put: 'Complex';
		at: TFDataTypeEnum tfComplex128 value put: 'Complex128';
		at: TFDataTypeEnum tfComplex64 value put: 'Complex64';
		at: TFDataTypeEnum tfDouble value put: 'Double';
		at: TFDataTypeEnum tfFloat value put: 'Float';
		at: TFDataTypeEnum tfHalf value put: 'Half';
		at: TFDataTypeEnum tfInt16 value put: 'Int16';
		at: TFDataTypeEnum tfInt32 value put: 'Int32';
		at: TFDataTypeEnum tfInt64 value put: 'Int64';
		at: TFDataTypeEnum tfInt8 value put: 'Int8';
		at: TFDataTypeEnum tfQint16 put: 'QInt16';
		at: TFDataTypeEnum tfQint32 put: 'QInt32';
		at: TFDataTypeEnum tfQint8 put: 'QInt8';
		at: TFDataTypeEnum tfQuint16 put: 'QUInt16';
		at: TFDataTypeEnum tfQuint8 put: 'QUInt8';
		at: TFDataTypeEnum tfResource put: 'Resource';
		at: TFDataTypeEnum tfString value put: 'String';
		at: TFDataTypeEnum tfUint16 value put: 'UInt16';
		at: TFDataTypeEnum tfUint32 value put: 'Uint32';
		at: TFDataTypeEnum tfUint64 value put: 'Uint64';
		at: TFDataTypeEnum tfUint8 value put: 'Uint8';
		at: TFDataTypeEnum tfVariant put: 'Variant';
		at: aType
]

{ #category : #'*TFOperationModel' }
TFTensor >> isScalar [
	^self rank = 0
]

{ #category : #'*TFOperationModel' }
TFTensor >> outputOn: aGraph [

	^(self asOperationOn: aGraph) outputOn: aGraph
]

{ #category : #'*TFOperationModel' }
TFTensor >> shapeDescription [

	^self shape description
]

{ #category : #'*TFOperationModel' }
TFTensor >> typeDescription [

	^self class descriptionOf: self type
]
