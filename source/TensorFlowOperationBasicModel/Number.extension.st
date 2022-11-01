Extension { #name : #Number }

{ #category : #'*TensorFlowOperationBasicModel' }
Number >> asOperationOn: aGraph [

	^self asTensor asOperationOn: aGraph
]

{ #category : #'*TensorFlowOperationBasicModel' }
Number >> outputOn: aComputation [

	^ ( self asOperationOn: aComputation ) value firstOutput
]
