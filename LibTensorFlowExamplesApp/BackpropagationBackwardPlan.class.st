Class {
	#name : #BackpropagationBackwardPlan,
	#superclass : #ExamplePlan,
	#category : 'LibTensorFlowExamplesApp'
}

{ #category : #initialization }
BackpropagationBackwardPlan >> initializeGraph [
	| inputVariable weights actual delta learningRate newWeights target one |
	super initializeGraph.
	inputVariable := graph placeholder: 'Input' type: TFTensor typeFloat.
	target := graph placeholder: 'target' type: TFTensor typeFloat.
	actual := graph placeholder: 'actual' type: TFTensor typeFloat.
	weights := graph placeholder: 'weights' type: TFTensor typeFloat.
	learningRate := graph const: 'learningRate' value: 0.9 asTensor.
	one := graph const: 'one' value: 1.0 asTensor.
	delta := (target - actual) negated @* actual @* (one - actual) @* inputVariable.
	newWeights := weights - (learningRate @* delta).
	outputs := {newWeights output: 0}.
	inputs := {inputVariable input: 0. weights input: 0. target input:0. actual input: 0}
]
