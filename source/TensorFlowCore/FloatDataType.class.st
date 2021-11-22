Class {
	#name : #FloatDataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #accessing }
FloatDataType >> description [

	^'Float'
]

{ #category : #comparing }
FloatDataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray floatAt: ( anIndex - 1 ) * self dataSize + 1
]

{ #category : #comparing }
FloatDataType >> put: aValue at: anIndex in: anExternalAddressOrByteArray [

	^ anExternalAddressOrByteArray floatAt: anIndex * self dataSize + 1 put: aValue asFloat
]

{ #category : #accessing }
FloatDataType >> uniqueIdentifier [

	^1
]
