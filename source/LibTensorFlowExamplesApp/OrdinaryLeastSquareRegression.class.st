Class {
	#name : #OrdinaryLeastSquareRegression,
	#superclass : #Object,
	#instVars : [
		'prediction',
		'tf'
	],
	#category : #LibTensorFlowExamplesApp
}

{ #category : #'Instance Creation' }
OrdinaryLeastSquareRegression class >> new [

	^super new initialize
]

{ #category : #Predicting }
OrdinaryLeastSquareRegression >> findWeightsThatFits: aTensor toPredict: anExpectedTensor [

	^tf
		compute: prediction
		feedingInputsWith: (
			Dictionary new
				at: 'x' put: aTensor;
				at: 'y' put: anExpectedTensor;
				yourself)
]

{ #category : #Initialization }
OrdinaryLeastSquareRegression >> initialize [

	| x y |

	tf := TensorFlowComputation new.
	x := tf floatInputNamed: 'x'.
	y := tf floatInputNamed: 'y'.

	prediction := (MatrixInverse of: (x transposedDot: x)) dot: (x transposedDot: y)
]