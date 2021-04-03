Class {
	#name : #Softmax,
	#superclass : #ActivationFunction,
	#instVars : [
		'neuron'
	],
	#category : 'TFOperationModel'
}

{ #category : #'Instance Creation' }
Softmax class >> activating: aNeuron [

	^self named: self operationType activating: aNeuron
]

{ #category : #'Instance Creation' }
Softmax class >> named: anOperationName activating: aNeuron [

	^self new initializeNamed: anOperationName activating: aNeuron
]

{ #category : #Accessing }
Softmax class >> operationType [

	^'Softmax'
]

{ #category : #Accessing }
Softmax >> currentComputation [

	^neuron currentComputation
]

{ #category : #Initialization }
Softmax >> initializeNamed: anOperationName activating: aNeuron [

	neuron := aNeuron.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: neuron
]

{ #category : #Printing }
Softmax >> printOn: aStream [

	aStream nextPutAll: ('softmax(<1p>)' expandMacrosWith: neuron)
]