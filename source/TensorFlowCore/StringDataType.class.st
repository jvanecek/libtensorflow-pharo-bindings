Class {
	#name : #StringDataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #comparing }
StringDataType >> dataSize [

	^ 24
]

{ #category : #accessing }
StringDataType >> description [

	^'String'
]

{ #category : #comparing }
StringDataType >> getElementAt: anIndex in: aByteArray [

	^ TFString fromHandle: aByteArray getHandle + ( ( anIndex - 1 ) * self dataSize )
]

{ #category : #comparing }
StringDataType >> put: aString at: anIndex in: anExternalAddress [

	^ TensorFlowCAPI current
		newStringOn: ( TFString fromHandle: anExternalAddress + ( anIndex * self dataSize ) )
		with: aString
]

{ #category : #accessing }
StringDataType >> uniqueIdentifier [

	^7
]
