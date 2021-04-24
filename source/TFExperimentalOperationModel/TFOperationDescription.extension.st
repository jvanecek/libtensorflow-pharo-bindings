Extension { #name : #TFOperationDescription }

{ #category : #'*TFExperimentalOperationModel' }
TFOperationDescription >> atPaddingPut: aListOfIntegers [

	^self at: 'padding' putString: aListOfIntegers
]

{ #category : #'*TFExperimentalOperationModel' }
TFOperationDescription >> atStridesPut: aListOfIntegers [

	^self at: 'strides' putInts: aListOfIntegers
]
