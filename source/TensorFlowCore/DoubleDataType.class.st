Class {
	#name : #DoubleDataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #accessing }
DoubleDataType >> description [

	^'Double'
]

{ #category : #comparing }
DoubleDataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray doubleAt: ( anIndex - 1 ) * self dataSize + 1
]

{ #category : #comparing }
DoubleDataType >> put: aValue at: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray doubleAt: anIndex * self dataSize + 1 put: aValue
]

{ #category : #accessing }
DoubleDataType >> uniqueIdentifier [

	^2
]
