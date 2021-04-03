Class {
	#name : #ElementWiseNegative,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'operationName',
		'operandToNegate'
	],
	#category : 'TFOperationModel'
}

{ #category : #'Instance Creation' }
ElementWiseNegative class >> named: aString of: aTFOperation [

	^self new initializeNamed: aString of: aTFOperation
]

{ #category : #'Instance Creation' }
ElementWiseNegative class >> of: anOperand [

	^self named: self operationType of: anOperand
]

{ #category : #'Instance Creation' }
ElementWiseNegative class >> operationType [

	^'Neg'
]

{ #category : #Accessing }
ElementWiseNegative >> currentComputation [

	^operandToNegate currentComputation
]

{ #category : #Initialization }
ElementWiseNegative >> initializeNamed: anOperationName of: anOperand [

	operandToNegate := anOperand.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: operandToNegate
]

{ #category : #Printing }
ElementWiseNegative >> printOn: aStream [

	aStream nextPutAll: '(- '.
	self print: operandToNegate formattedOn: aStream.
	aStream nextPutAll: ')'
]