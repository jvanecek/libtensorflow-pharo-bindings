Extension { #name : #RectifiedLinearTest }

{ #category : #'*TFOperationGradientModelTests' }
RectifiedLinearTest >> testDerivativeWithRespectToAnInvalidInput [

	| negativeScalar positiveScalar |

	negativeScalar := tf constantWith: -1.5.
	positiveScalar := tf constantWith: 4.0.

	self
		assert: (RectifiedLinear activating: negativeScalar)
		isNotDifferentiableRespectTo: positiveScalar
]

{ #category : #'*TFOperationGradientModelTests' }
RectifiedLinearTest >> testGradientOfReluOfFloatScalar [

	| negativeScalar positiveScalar |

	negativeScalar := tf constantWith: -1.5.
	positiveScalar := tf constantWith: 4.0.

	self
		assertPartialDerivativeOf: (RectifiedLinear activating: negativeScalar)
			withRespectTo: negativeScalar
			isCloseTo: 0;
		assertPartialDerivativeOf: (RectifiedLinear activating: positiveScalar)
			withRespectTo: positiveScalar
			isCloseTo: 1
]

{ #category : #'*TFOperationGradientModelTests' }
RectifiedLinearTest >> testGradientOfReluOfFloatVector [

	| input relu |

	input := tf variableNamed: 'input' with: #(-1 4 -0.4 5) asFloatTensor.

	relu := RectifiedLinear activating: input.

	self assertPartialDerivativeOf: relu withRespectTo: input isVectorCloseTo: #(0 1 0 1)
]
