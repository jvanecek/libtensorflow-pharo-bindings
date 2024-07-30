Class {
	#name : #FlattenLayer,
	#superclass : #SequentialModelLayer,
	#instVars : [
		'input'
	],
	#category : #NeuralNetworkLayerModel
}

{ #category : #'Not categorized' }
FlattenLayer class >> receiving: anInputTensor [

	^ self new initializeReceiving: anInputTensor
]

{ #category : #Accessing }
FlattenLayer >> currentComputation [

	^value currentComputation
]

{ #category : #Initialization }
FlattenLayer >> initializeReceiving: anInputTensor [

	input := anInputTensor.
	value := input reshapeFlattened 
]

{ #category : #Accessing }
FlattenLayer >> inputVariableName [

	^input operationName
]

{ #category : #Printing }
FlattenLayer >> printOn: aStream [

	aStream nextPutAll: 'Flatten Layer'
]

{ #category : #Accessing }
FlattenLayer >> trainableVariables [

	^#()
]
