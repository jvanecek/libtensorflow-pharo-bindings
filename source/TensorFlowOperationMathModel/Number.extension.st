Extension { #name : #Number }

{ #category : #'*TensorFlowOperationMathModel' }
Number >> outputOn: aComputation [

	^ ( self asOperationOn: aComputation ) value firstOutput
]
