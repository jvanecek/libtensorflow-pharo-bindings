Class {
	#name : #ShapeOperation,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'tensor'
	],
	#category : #TFOperationModel
}

{ #category : #'Instance Creation' }
ShapeOperation class >> named: anOperationName of: anOperationNode [

	^self new initializeNamed: anOperationName of: anOperationNode
]

{ #category : #'Instance Creation' }
ShapeOperation class >> of: anOperationNode [

	^self named: self operationType of: anOperationNode
]

{ #category : #Accessing }
ShapeOperation class >> operationType [

	^'Shape'
]

{ #category : #Accessing }
ShapeOperation >> currentComputation [

	^tensor currentComputation
]

{ #category : #Initialization }
ShapeOperation >> initializeNamed: anOperationName of: anOperationNode [

	tensor := anOperationNode.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: anOperationNode
]
