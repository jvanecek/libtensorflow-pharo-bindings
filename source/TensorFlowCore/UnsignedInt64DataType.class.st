Class {
	#name : #UnsignedInt64DataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #accessing }
UnsignedInt64DataType >> description [

	^'Uint64'
]

{ #category : #comparing }
UnsignedInt64DataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray unsignedLongLongAt: ( anIndex - 1 ) * self dataSize + 1
]

{ #category : #accessing }
UnsignedInt64DataType >> uniqueIdentifier [

	^23
]
