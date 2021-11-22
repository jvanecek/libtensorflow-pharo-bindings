Class {
	#name : #Int64DataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #accessing }
Int64DataType >> description [

	^'Int64'
]

{ #category : #comparing }
Int64DataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray signedLongLongAt: ( anIndex - 1 ) * self dataSize + 1
]

{ #category : #comparing }
Int64DataType >> put: aValue at: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray signedLongLongAt: anIndex * self dataSize + 1 put: aValue
]

{ #category : #accessing }
Int64DataType >> uniqueIdentifier [ 

	^ 9
]
