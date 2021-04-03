Class {
	#name : #IndexWithMinimum,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'tensor',
		'axis'
	],
	#category : 'TFOperationModel'
}

{ #category : #'Instance Creation' }
IndexWithMinimum class >> in: aTensor across: anAxis [

	^self named: self operationType in: aTensor across: anAxis
]

{ #category : #'Instance Creation' }
IndexWithMinimum class >> named: anOperationName in: aTensor across: anAxis [

	^self new initializeNamed: anOperationName in: aTensor across: anAxis
]

{ #category : #Accessing }
IndexWithMinimum class >> operationType [

	^'ArgMin'
]

{ #category : #Accessing }
IndexWithMinimum >> currentComputation [

	^tensor currentComputation
]

{ #category : #Initialization }
IndexWithMinimum >> initializeNamed: anOperationName in: aTensor across: anAxis [

	tensor := aTensor.
	axis := anAxis.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: tensor
			with: axis asInt32Tensor
]