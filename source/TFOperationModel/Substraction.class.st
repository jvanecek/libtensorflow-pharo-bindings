Class {
	#name : #Substraction,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'leftOperand',
		'rightOperand'
	],
	#category : 'TFOperationModel'
}

{ #category : #'Instance Creation' }
Substraction class >> named: anOperationName of: aLeftOperand minus: aRightOperand [

	^self new initializeNamed: anOperationName of: aLeftOperand minus: aRightOperand
]

{ #category : #'Instance Creation' }
Substraction class >> of: aLeftOperand minus: aRightOperand [

	^self named: self operationType of: aLeftOperand minus: aRightOperand
]

{ #category : #Accessing }
Substraction class >> operationType [

	^'Sub'
]

{ #category : #Accessing }
Substraction >> currentComputation [

	^leftOperand currentComputation
]

{ #category : #Initialization }
Substraction >> initializeNamed: anOperationName of: aLeftOperand minus: aRightOperand [

	leftOperand := aLeftOperand.
	rightOperand := aRightOperand.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: leftOperand
			with: rightOperand
]

{ #category : #Printing }
Substraction >> printOn: aStream [

	aStream nextPutAll: '('. 
	self print: leftOperand formattedOn: aStream. 
	aStream nextPutAll: ' - '. 
	self print: rightOperand formattedOn: aStream. 
	aStream nextPutAll: ')'. 
]