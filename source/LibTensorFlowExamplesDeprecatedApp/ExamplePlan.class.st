Class {
	#name : #ExamplePlan,
	#superclass : #Object,
	#instVars : [
		'graph',
		'inputs',
		'outputs',
		'session'
	],
	#category : #LibTensorFlowExamplesDeprecatedApp
}

{ #category : #initialization }
ExamplePlan >> initialize [
	self initializeGraph.
	self initializeSession.
]

{ #category : #initialization }
ExamplePlan >> initializeGraph [
	graph := TFGraph create
	
]

{ #category : #initialization }
ExamplePlan >> initializeSession [
	session := TFSession on: graph.
	graph initializeOn: session.

]

{ #category : #running }
ExamplePlan >> runOn: inputValues [
	| results |	
	results := session
		runInputs: inputs
		values: inputValues
		outputs: outputs.
		
	^ results first
	
]
