Extension { #name : #TensorFlowCAPISlowTests }

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPISlowTests >> mulGraphTwoInputsInt64ConstTensorDeleted [
	^ TensorFlowCAPITest new mulGraphTwoInputsInt64ConstTensorDeleted
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPISlowTests >> testRunGraphMulTwoInputsConstTensorDeleted [

	| graph inputs inputValues mul output session results |

	graph := self mulGraphTwoInputsInt64ConstTensorDeleted.
	inputs := Array
		with: ( ( graph operationNamed: 'in1' ) input: 0 )
		with: ( ( graph operationNamed: 'in2' ) input: 0 ).
	inputValues := Array with: ( TFTensor fromInt64: 16r23 ) with: ( TFTensor fromInt64: 16r24 ).
	Smalltalk garbageCollect.
	( TFTensor fromInt64: 16r1234123412341234 ) autoRelease.
	Smalltalk garbageCollect.
	mul := graph operationNamed: 'mul2'.
	output := mul output: 0.
	session := TFSession on: graph.
	results := session runInputs: inputs values: inputValues outputs: ( Array with: output ).
	self deny: results first isNull.
	self deny: results first data isNull.
	self
		assert: ( results first data getHandle signedLongLongAt: 1 )
		equals: ( 16r2121212121212121 * 16r23 * 16r24 bitAnd: 16rFFFFFFFFFFFFFFFF )
]

{ #category : #'*TensorFlowDeprecatedCoreTests' }
TensorFlowCAPISlowTests >> testRunGraphMulTwoInputsConstTensorDeletedManyTimes [
	20 timesRepeat: [ self testRunGraphMulTwoInputsConstTensorDeleted ]
]
