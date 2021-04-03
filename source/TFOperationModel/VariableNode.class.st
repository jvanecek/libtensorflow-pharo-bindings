Class {
	#name : #VariableNode,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'currentComputation',
		'currentValueAssigned'
	],
	#category : #TFOperationModel
}

{ #category : #'Instance Creation' }
VariableNode class >> on: aComputation named: aName forFloatsShaped: aShape initializedWith: aVariableInitializer [

	^self
		on: aComputation
		named: aName
		of: TFTensor typeFloat
		shaped: aShape
		initializedWith: aVariableInitializer
]

{ #category : #'Instance Creation' }
VariableNode class >> on: aComputation named: aName of: aType shaped: aShape initializedWith: aVariableInitializer [

	^self new
		initializeOn: aComputation
		named: aName
		of: aType
		shaped: aShape
		initializedWith: aVariableInitializer
]

{ #category : #configuring }
VariableNode >> assign: anOperation [

	currentValueAssigned := currentComputation
		newOperationOf: 'Assign'
		namePrefixed: self operationName , '_initializer'
		with: self 
		with: anOperation
]

{ #category : #Accessing }
VariableNode >> currentComputation [

	^currentComputation
]

{ #category : #Initialization }
VariableNode >> initializeOn: aTensorFlowComputation named: aName of: aType shaped: aShape initializedWith: aVariableInitializer [

	currentComputation := aTensorFlowComputation.
	value :=
		aTensorFlowComputation
			newOperationOf: self operationType
			namePrefixed: aName
			withAll: #()
			describedBy: [:description |
				description
					atDataTypePut: aType;
					atShapePut: aShape].
	aVariableInitializer applyTo: self
]

{ #category : #Accessing }
VariableNode >> operationType [

	^'Variable'
]
