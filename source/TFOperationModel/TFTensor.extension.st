Extension { #name : #TFTensor }

{ #category : #'*TFOperationModel' }
TFTensor >> asOperationOn: aComputation [

	^ ConstantNode on: aComputation with: self
]

{ #category : #'*TFOperationModel' }
TFTensor >> outputOn: aComputation [

	^ ( self asOperationOn: aComputation ) value firstOutput
]

{ #category : #'*TFOperationModel' }
TFTensor >> printOn: aStream [

	aStream nextPutAll:
		('<1s> <2s>' expandMacrosWith: self typeDescription with: self shapeDescription asLowercase)
]

{ #category : #'*TFOperationModel' }
TFTensor >> shapeDescription [

	^self shape description
]

{ #category : #'*TFOperationModel' }
TFTensor >> typeDescription [

	^self class descriptionOf: self type
]
