Extension { #name : #Number }

{ #category : #'*TensorFlowOperationMathModelTests' }
Number >> sigmoid [

	" sigmoid function "

	^1 / (1 + (self negated exp))
]
