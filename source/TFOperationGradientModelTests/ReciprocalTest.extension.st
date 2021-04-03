Extension { #name : #ReciprocalTest }

{ #category : #'*TFOperationGradientModelTests' }
ReciprocalTest >> testGradientWithRespectToScalarInput [
	"f(x) = 1/x
	 df/dx = -1/x^2"

	| x y |
	self skip. " This test is crashing the image in the github actions CI"
	x := tf constantWith: 4.0.

	y := Reciprocal of: x.

	self assertPartialDerivativeOf: y withRespectTo: x isCloseTo: (-1 / (4 * 4))
]

{ #category : #'*TFOperationGradientModelTests' }
ReciprocalTest >> testGradientWithRespectToVectorInput [

	| x y |

	self skip.	" This test is crashing the image in the github actions CI"
	x := tf floatConstantWith: #(5 10 -0.5).

	y := Reciprocal of: x.

	self
		assertPartialDerivativeOf: y
		withRespectTo: x
		isVectorCloseTo: ( Array with: -1 / 25 with: -1 / 100 with: -4 )
]