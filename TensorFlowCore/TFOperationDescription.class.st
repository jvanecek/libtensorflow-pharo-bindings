"
Operation being built. The underlying graph must outlive this.
"
Class {
	#name : #TFOperationDescription,
	#superclass : #FFIOpaqueObject,
	#category : #TensorFlowCore
}

{ #category : #finalization }
TFOperationDescription class >> basicNew [

^super basicNew autoRelease
]

{ #category : #finalization }
TFOperationDescription class >> finalizeResourceData: handle [


]

{ #category : #accessing }
TFOperationDescription >> add: input [
	"To be removed maybe ?"

	self halt.
	self library description: self addInput: input
]

{ #category : #inputs }
TFOperationDescription >> addControlInput: aTF_OutputOrInput [
	^ self library description: self addControlInput: aTF_OutputOrInput
]

{ #category : #inputs }
TFOperationDescription >> addInput: aTF_OutputOrInput [
	^ self library description: self addInput: aTF_OutputOrInput
]

{ #category : #inputs }
TFOperationDescription >> addInputFromOutput: indexInteger of: aTF_Operation [
	| input |
	input := aTF_Operation input: indexInteger.
	[ self library description: self addInput: input ]
		ensure: [ input free ]
]

{ #category : #inputs }
TFOperationDescription >> addInputs: anArrayOfTF_Output [
	| inputs |
	inputs := TFOutputArray fromCollection: anArrayOfTF_Output.
	self library description: self addInputs: inputs size: anArrayOfTF_Output size
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putBoolean: value [
	self library description: self set: attribute asAsciiZ toBool: value
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putFloat: value [
	self library description: self set: attribute asAsciiZ toFloat: value asFloat
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putInt: value [
	self library description: self set: attribute asAsciiZ toInt64: value
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putShape: aTensorShape [
	| status value |
	value := FFIExternalArray externalNewType: 'int64' fromArray: aTensorShape dimensionSizes.
	status := TFStatus create.
	self library
		description: self
		set: attribute asAsciiZ
		toShape: value getHandle
		size: aTensorShape dimensionSizes size.
	status check
]

{ #category : #attributes }
TFOperationDescription >> at: aString putShapes: aListOfShapes [

	| status pointers shapes shapeSizes |

	shapes := aListOfShapes
		collect:
			[ :shape | ( FFIExternalArray externalNewType: 'int64' fromArray: shape dimensionSizes ) autoRelease ].
	pointers := ByteArray new: Smalltalk wordSize * shapes size.
	shapes
		withIndexDo: [ :each :index | pointers pointerAt: ( index - 1 ) * Smalltalk wordSize + 1 put: each getHandle ].

	shapeSizes := aListOfShapes collect: #rank.
	status := TFStatus create.
	self library
		description: self
		set: aString asAsciiZ
		toShapes: pointers 
		sizesOfEach: ( FFIExternalArray externalNewType: 'int32' fromArray: shapeSizes ) getHandle
		size: aListOfShapes size.
	status check
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putString: aString [
	| status |
	status := TFStatus create.
	self library
		description: self
		set: attribute asAsciiZ
		toString: aString
		size: aString size.
	status check
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putStrings: anArrayOfStrings [
	| status sizes strings pointers |
	sizes := anArrayOfStrings collect: [:str | str size].
	sizes := FFIExternalArray externalNewType: 'int64' fromArray: sizes.
	sizes autoRelease.
	strings := anArrayOfStrings collect: [:each | (self library externalizeString: each) autoRelease].
	pointers := ByteArray new: Smalltalk wordSize * strings size.
	strings withIndexDo: [:each :index |
		pointers pointerAt: index-1*Smalltalk wordSize+1 put: each].
	 
	status := TFStatus create.
	self library
		description: self
		set: attribute asAsciiZ
		toStrings: pointers
		sizes: sizes getHandle
		count: anArrayOfStrings size.
	status check
	
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putTensor: aTF_Tensor [
	| status |
	status := TFStatus create.
	self library
		description: self
		set: attribute asAsciiZ
		toTensor: aTF_Tensor
		status: status.
	status check
]

{ #category : #attributes }
TFOperationDescription >> at: attribute putType: value [
	self library description: self set: attribute asAsciiZ toType: value
]

{ #category : #attributes }
TFOperationDescription >> at: anAttributeName putTypes: aListOfTypes [

	| status |

	status := TFStatus create.
	self library
		description: self
		set: anAttributeName
		toTypes: ( FFIExternalArray externalNewType: 'int32' fromArray: aListOfTypes ) getHandle
		size: aListOfTypes size.
	status check
]

{ #category : #attributes }
TFOperationDescription >> device: aString [
	^ self library description: self setDevice: aString
]

{ #category : #accessing }
TFOperationDescription >> finish [
	| answer status |
	status := TFStatus create.
	answer := self library finishOperation: self status: status.
	"handle := nil."
	status check.
	^ answer
]

{ #category : #attributes }
TFOperationDescription >> library [
	^ TensorFlowCAPI current
]
