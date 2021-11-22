Class {
	#name : #BooleanDataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #accessing }
BooleanDataType >> description [

	^'Boolean'
]

{ #category : #comparing }
BooleanDataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray booleanAt: ( anIndex - 1 ) * self dataSize + 1
]

{ #category : #comparing }
BooleanDataType >> put: aValue at: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray booleanAt: anIndex * self dataSize + 1 put: aValue
]

{ #category : #accessing }
BooleanDataType >> uniqueIdentifier [

	^ 10 
]
