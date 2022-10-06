Extension { #name : #TFTensor }

{ #category : #'*TensorFlowOperationBasicModel' }
TFTensor >> asOperationOn: aComputation [

	^ ConstantTensor on: aComputation with: self
]

{ #category : #'*TensorFlowOperationBasicModel' }
TFTensor >> outputOn: aComputation [

	^ ( self asOperationOn: aComputation ) value firstOutput
]

{ #category : #'*TensorFlowOperationBasicModel' }
TFTensor >> printOn: aStream [

	aStream nextPutAll:
		('<1s> <2s>' expandMacrosWith: self typeDescription with: self shapeDescription asLowercase)
]

{ #category : #'*TensorFlowOperationBasicModel' }
TFTensor >> shapeDescription [

	^self shape description
]

{ #category : #'*TensorFlowOperationBasicModel' }
TFTensor >> typeDescription [

	^ self type description
]
