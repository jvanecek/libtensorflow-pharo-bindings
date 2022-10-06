Extension { #name : #MeanSquaredErrorTest }

{ #category : #'*TensorFlowOperationGradientModelTests' }
MeanSquaredErrorTest >> testGradientOfMSEBetweenTwoConstantScalars [

	| prediction expected mse |

	prediction := tf floatConstantWith: 3 named: 'prediction'.
	expected := tf constantWith: Float pi.

	mse := MeanSquaredError of: prediction whenExpectedIs: expected.

	self assertPartialDerivativeOf: mse withRespectTo: prediction isCloseTo: 2 * (3 - Float pi)
]
