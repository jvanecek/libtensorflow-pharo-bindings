Class {
	#name : #RectifiedLinear,
	#superclass : #ActivationFunction,
	#instVars : [
		'neuron'
	],
	#category : 'TFOperationModel'
}

{ #category : #'Instance Creation' }
RectifiedLinear class >> activating: aNeuron [

	^self named: self operationType activating: aNeuron
]

{ #category : #'Instance Creation' }
RectifiedLinear class >> named: anOperationName activating: aNeuron [

	^self new initializeNamed: anOperationName activating: aNeuron
]

{ #category : #Accessing }
RectifiedLinear class >> operationType [

	^'Relu'
]

{ #category : #Accessing }
RectifiedLinear >> currentComputation [

	^neuron currentComputation
]

{ #category : #Initialization }
RectifiedLinear >> initializeNamed: anOperationName activating: aNeuron [

	neuron := aNeuron.
	value :=
		neuron currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: neuron
]

{ #category : #Printing }
RectifiedLinear >> printOn: aStream [

	aStream nextPutAll: ('relu(<1p>)' expandMacrosWith: neuron)
]