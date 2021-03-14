Class {
	#name : #BackpropagationForwardPlan,
	#superclass : #ExamplePlan,
	#category : 'LibTensorFlowExamplesApp'
}

{ #category : #initialization }
BackpropagationForwardPlan >> initializeGraph [
	| activation inputVariable netInput weights |
	super initializeGraph.
	inputVariable := graph placeholder: 'Input' type: TFTensor typeFloat.
	weights := graph placeholder: 'weights' type: TFTensor typeFloat.
	netInput := weights * inputVariable.
	activation := netInput sigmoid.
	outputs := {activation output: 0}.
	inputs := {inputVariable input: 0. weights input: 0}
]
