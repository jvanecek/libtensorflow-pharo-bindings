Class {
	#name : #Shape,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'tensor'
	],
	#category : 'TFOperationModel'
}

{ #category : #'Instance Creation' }
Shape class >> named: anOperationName of: anOperationNode [

	^self new initializeNamed: anOperationName of: anOperationNode
]

{ #category : #'Instance Creation' }
Shape class >> of: anOperationNode [

	^self named: self operationType of: anOperationNode
]

{ #category : #Accessing }
Shape class >> operationType [

	^'Shape'
]

{ #category : #Accessing }
Shape >> currentComputation [

	^tensor currentComputation
]

{ #category : #Initialization }
Shape >> initializeNamed: anOperationName of: anOperationNode [

	tensor := anOperationNode.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: anOperationNode
]
