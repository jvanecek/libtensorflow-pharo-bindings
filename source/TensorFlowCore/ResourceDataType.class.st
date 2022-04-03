Class {
	#name : #ResourceDataType,
	#superclass : #TensorDataType,
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #accessing }
ResourceDataType >> description [

	^'Resource'
]

{ #category : #accessing }
ResourceDataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [
	" Not sure if should be reading 64bit integer, but anyway to access the elements 
	 stored in the resource should be using ResourceVariableNode>>#underlayingValue. 
	Can't use the #signedLongLongAt: as is not backward compatible
	"

	^ anExternalAddressOrByteArray integerAt: ( anIndex - 1 ) * self dataSize  + 1 size: 8 signed: true
]

{ #category : #accessing }
ResourceDataType >> put: aValue at: anIndex in: anExternalAddressOrByteArray [
	" Not sure if should be reading 64bit integer, but anyway to access the elements 
	 stored in the resource should be using ResourceVariableNode>>#underlayingValue " 
	 
	^anExternalAddressOrByteArray signedLongLongAt: anIndex * self dataSize put: aValue
]

{ #category : #accessing }
ResourceDataType >> uniqueIdentifier [

	^20
]
