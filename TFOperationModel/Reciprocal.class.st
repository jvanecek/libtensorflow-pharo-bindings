Class {
	#name : #Reciprocal,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'operation'
	],
	#category : 'TFOperationModel'
}

{ #category : #'Instance Creation' }
Reciprocal class >> named: aName of: anOperation [

	^self new initializeNamed: aName of: anOperation
]

{ #category : #'Instance Creation' }
Reciprocal class >> of: anOperation [

	^self named: self operationType of: anOperation
]

{ #category : #Accessing }
Reciprocal class >> operationType [

	^'Reciprocal'
]

{ #category : #Accessing }
Reciprocal >> currentComputation [

	^operation currentComputation
]

{ #category : #Initialization }
Reciprocal >> initializeNamed: aName of: anOperation [

	operation := anOperation.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: aName
			with: operation
]

{ #category : #Printing }
Reciprocal >> printOn: aStream [

	aStream nextPutAll: ('1 / (<1p>)' expandMacrosWith: operation)
]
