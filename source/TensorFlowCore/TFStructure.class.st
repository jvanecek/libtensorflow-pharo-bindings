"
Root class of all TF_XXX structures
"
Class {
	#name : #TFStructure,
	#superclass : #FFIExternalStructure,
	#category : #TensorFlowCore
}

{ #category : #'class initialization' }
TFStructure class >> initialize [
	super initialize.
	self == TFStructure
		ifTrue: [ self allSubclassesDo: [ :cls | cls initialize ].
			self allSubclassesDo: [ :cls | cls initialize ] ]
]

{ #category : #'field definition' }
TFStructure class >> pointerSize [
	" Fixed for 64 bit platforms. TensorFlow is only available in 64 bit platforms "

	self assert: 8 == Smalltalk wordSize.
	^ Smalltalk wordSize
]

{ #category : #comparing }
TFStructure >> = aTF_Structure [
	^ self class = aTF_Structure class and: [ handle = aTF_Structure getHandle ]
]

{ #category : #private }
TFStructure >> library [
	^ TensorFlowCAPI current
]

{ #category : #printing }
TFStructure >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		print: handle
]
