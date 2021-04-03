"
This object was rewritten into NearestNeighborNetwork
"
Class {
	#name : #ExampleNearestNeighborPlan,
	#superclass : #ExamplePlan,
	#category : #LibTensorFlowExamplesDeprecatedApp
}

{ #category : #initialization }
ExampleNearestNeighborPlan >> initializeGraph [
	| neg add abs axis axisValue distance testing training prediction |
	super initializeGraph.
	
	training := graph placeholder: 'training' type: TFTensor typeFloat.
	testing := graph placeholder: 'testing' type: TFTensor typeFloat.
	axisValue := TFTensor fromInt32: 0.
	axis := graph const: 'axis' value: axisValue.
	neg := graph newOperation: 'Neg' named: 'neg' described: [:description |
		description addInput: (testing output: 0)].
	add := graph add: 'add' described:[:description| 
		description addInput: (neg output: 0).
		description addInput: (training output: 0).
		].
	abs := graph newOperation: 'Abs' named: 'abs' described: [:description|
		description addInput: (add output: 0)].
	distance := graph newOperation: 'Sum' named: 'distance' described: [:description|
		description addInput: (abs output: 0).
		description addInput: (axis output: 0).].
	
	prediction := graph newOperation: 'ArgMin' named: 'argmin' described:[:description|
		description addInput: (distance output: 0).
		description addInput: (axis output: 0)].
	
	outputs := {prediction output: 0}.
	inputs := {training input: 0. testing input: 0}.
]

{ #category : #initialization }
ExampleNearestNeighborPlan >> initializeGraphWithOperations [
	| axis distance testing training prediction |
	graph := TFGraph create.
	
	training := graph placeholder: 'training' type: TFTensor typeFloat.
	testing := graph placeholder: 'testing' type: TFTensor typeFloat.
	axis := 0 asInt32Tensor.
	
	distance := (testing - training) abs sumOn: axis.
	prediction := distance findMinOn: axis.
	
	outputs := {prediction output: 0}.
	inputs := {training input: 0. testing input: 0}.

]

{ #category : #evaluating }
ExampleNearestNeighborPlan >> predict: covariatesTesting from: covariatesTraining [
	| result |

 	result := self runOn: {covariatesTraining. covariatesTesting}.
	^ result allInt64s + 1
]
