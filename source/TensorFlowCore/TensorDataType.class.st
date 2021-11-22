Class {
	#name : #TensorDataType,
	#superclass : #Object,
	#classInstVars : [
		'singletons'
	],
	#category : #'TensorFlowCore-DataTypes'
}

{ #category : #'instance creation' }
TensorDataType class >> identifiedWith: aUniqueIdentifier [

	^(self subclasses detect: [:subclass | subclass new uniqueIdentifier = aUniqueIdentifier]) new
]

{ #category : #'instance creation' }
TensorDataType class >> new [

	singletons ifNil: [singletons := Dictionary new].
	^singletons at: self ifAbsentPut: [super new]
]

{ #category : #comparing }
TensorDataType >> = aDataType [

	^ self class = aDataType class
]

{ #category : #comparing }
TensorDataType >> dataSize [

	^TensorFlowCAPI current sizeOfDataType: self
]

{ #category : #comparing }
TensorDataType >> description [

	self subclassResponsibility
]

{ #category : #comparing }
TensorDataType >> getElementAt: anIndex in: anExternalAddressOrByteArray [ 
	
	self subclassResponsibility 
]

{ #category : #comparing }
TensorDataType >> hash [

	^self class hash
]

{ #category : #comparing }
TensorDataType >> put: aValue at: anIndex in: anExternalAddressOrByteArray [ 
	
	self subclassResponsibility 
]

{ #category : #comparing }
TensorDataType >> uniqueIdentifier [

	self subclassResponsibility
]
