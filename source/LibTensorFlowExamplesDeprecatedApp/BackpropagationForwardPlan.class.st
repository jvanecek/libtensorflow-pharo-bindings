Class {
	#name : #BackpropagationForwardPlan,
	#superclass : #ExamplePlan,
	#category : #LibTensorFlowExamplesDeprecatedApp
}

{ #category : #initialization }
BackpropagationForwardPlan >> initializeGraph [

	| activation inputVariable netInput weights |

	super initializeGraph.
	inputVariable := graph placeholder: 'Input' type: FloatDataType new.
	weights := graph placeholder: 'weights' type: FloatDataType new.
	netInput := weights * inputVariable.
	activation := netInput sigmoid.
	outputs := {( activation output: 0 )}.
	inputs := {( inputVariable input: 0 ).
	( weights input: 0 )}
]
