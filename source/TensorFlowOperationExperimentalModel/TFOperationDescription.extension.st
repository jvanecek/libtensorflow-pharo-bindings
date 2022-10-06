Extension { #name : #TFOperationDescription }

{ #category : #'*TensorFlowOperationExperimentalModel' }
TFOperationDescription >> atPaddingPut: aListOfIntegers [

	^self at: 'padding' putString: aListOfIntegers
]

{ #category : #'*TensorFlowOperationExperimentalModel' }
TFOperationDescription >> atStridesPut: aListOfIntegers [

	^self at: 'strides' putInts: aListOfIntegers
]
