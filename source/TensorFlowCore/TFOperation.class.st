"
Operation that has been added to the graph. Valid until the graph is deleted -- in particular adding a new operation to the graph does not  invalidate old TF_Operation* pointers.
"
Class {
	#name : #TFOperation,
	#superclass : #FFIOpaqueObject,
	#instVars : [
		'graph',
		'output'
	],
	#category : #TensorFlowCore
}

{ #category : #comparing }
TFOperation >> = aTF_Operation [
	^ self class = aTF_Operation class and: [ 
		" Doing this so different instances of the same pointer matches "
		handle asString  = aTF_Operation getHandle asString ]
]

{ #category : #converting }
TFOperation >> asOperationOn: aTF_Graph [
	graph == aTF_Graph
		ifTrue: [^ self]
		ifFalse: [^ self error: 'Can''t move an operation to another Graph']
]

{ #category : #attributes }
TFOperation >> attrMetadata: nameString [

	^ self library operation: self getMetadataFor: nameString asAsciiZ
]

{ #category : #attributes }
TFOperation >> boolAt: nameString [

	^self library operation: self getBoolAt: nameString asAsciiZ
]

{ #category : #accessing }
TFOperation >> device [
"The name of the device to which this op has been assigned, if any.
Returns: The string name of the device to which this op has been assigned, or an empty string if it has not been assigned to a device."
	^ self library operationDevice: self
]

{ #category : #accessing }
TFOperation >> firstInput [
	^ self input: 0
]

{ #category : #initialization }
TFOperation >> firstOutput [
	output ifNil: [ output := 0 ].
	^ self output: output
]

{ #category : #attributes }
TFOperation >> floatAt: nameString [

	^self library operation: self getFloatAt: nameString asAsciiZ
]

{ #category : #accessing }
TFOperation >> graph [
	"The Graph that contains this operation"
	
	^ graph
]

{ #category : #accessing }
TFOperation >> graph: aTF_Graph [
	graph := aTF_Graph
]

{ #category : #accessing }
TFOperation >> input: anInteger [
	"Return input at position anInteger"
	
	^ TFInput onOperation: self index: anInteger
]

{ #category : #accessing }
TFOperation >> inputsCount [
	"Returns number of inputs of this operation"
	
	^ self library operationNumInputs: self
]

{ #category : #attributes }
TFOperation >> intAt: nameString [

	^ self library operation: self getInt64At: nameString asAsciiZ
]

{ #category : #accessing }
TFOperation >> library [
	^ TensorFlowCAPI current
]

{ #category : #accessing }
TFOperation >> name [
	"The full name of this operation"
	
	^ self library operationName: self
]

{ #category : #initialization }
TFOperation >> output [
	"The list of Tensor objects representing the outputs of this op."

	output ifNil: [ output := 0 ].
	^ self output: output
]

{ #category : #accessing }
TFOperation >> output: anInteger [
	"Return output at position anInteger"
	
	^ TFOutput onOperation: self index: anInteger
]

{ #category : #accessing }
TFOperation >> outputsCount [
	"Returns number of inputs of this operation"
	
	^ self library operationNumOutputs: self
]

{ #category : #printing }
TFOperation >> printOn: stream [
	super printOn: stream.
	handle isNull
		ifFalse: [ stream
				space;
				print: self type;
				space;
				print: self name ]
]

{ #category : #attributes }
TFOperation >> shapeAt: nameString [

	^self library operation: self getShapeAt: nameString asAsciiZ
]

{ #category : #attributes }
TFOperation >> stringAt: nameString [

	^ self library operation: self getStringAt: nameString asAsciiZ
]

{ #category : #attributes }
TFOperation >> stringsAt: nameString [

	^self library operation: self getStringsAt: nameString asAsciiZ
]

{ #category : #attributes }
TFOperation >> tensorAt: nameString [

	^self library operation: self getTensorAt: nameString asAsciiZ
]

{ #category : #accessing }
TFOperation >> type [
	"The type of the op (e.g. MatMul)"

	^ self library operationOpType: self
]

{ #category : #attributes }
TFOperation >> typeAt: nameString [

	^self library operation: self getTypeAt: nameString asAsciiZ
]

{ #category : #accessing }
TFOperation >> useOutput: anInteger [
	output := anInteger
]
