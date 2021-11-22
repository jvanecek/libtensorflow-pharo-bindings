Class {
	#name : #Int32DataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #accessing }
Int32DataType >> description [

	^'Int32'
]

{ #category : #comparing }
Int32DataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray signedLongAt: ( anIndex - 1 ) * self dataSize + 1
]

{ #category : #comparing }
Int32DataType >> put: aValue at: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray signedLongAt: anIndex * self dataSize + 1 put: aValue
]

{ #category : #accessing }
Int32DataType >> uniqueIdentifier [

	^3
]
