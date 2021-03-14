Extension { #name : #TensorFlowComputationBasedTest }

{ #category : #'*TFOperationGradientModelTests' }
TensorFlowComputationBasedTest >> assert: anOperation isNotDifferentiableRespectTo: anInput [

	self
		should: [anOperation partialDerivativeWithRespectTo: anInput]
		raise: Error
		withDescription: (
			'INVALID_ARGUMENT: Cannot compute the partial derivative for node ''<1s>'' as it''s unreachable from the output node(s).'
				expandMacrosWith: anInput operationName)
]

{ #category : #'*TFOperationGradientModelTests' }
TensorFlowComputationBasedTest >> assertPartialDerivativeOf: anOperation withRespectTo: anInput isCloseTo: anExpectedValue [

	self
		assertOutputOf: (anOperation partialDerivativeWithRespectTo: anInput)
		isFloatScalarCloseTo: anExpectedValue
]

{ #category : #'*TFOperationGradientModelTests' }
TensorFlowComputationBasedTest >> assertPartialDerivativeOf: anOperation withRespectTo: anInput isMatrixCloseTo: anExpectedValue [

	self
		assertOutputOf: (anOperation partialDerivativeWithRespectTo: anInput)
		isMatrixCloseTo: anExpectedValue
]

{ #category : #'*TFOperationGradientModelTests' }
TensorFlowComputationBasedTest >> assertPartialDerivativeOf: anOperation withRespectTo: anInput isVectorCloseTo: anExpectedValue [

	self
		assertOutputOf: (anOperation partialDerivativeWithRespectTo: anInput)
		isFloatVectorCloseTo: anExpectedValue
]
