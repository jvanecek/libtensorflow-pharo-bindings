Class {
	#name : #TFAutoReleasableResource,
	#superclass : #FFIOpaqueObject,
	#category : #'TensorFlowCore-Structures'
}

{ #category : #finalization }
TFAutoReleasableResource class >> deleteExternalResource: aResource [

	self subclassResponsibility 
]

{ #category : #finalization }
TFAutoReleasableResource class >> finalizeResourceData: aResource [

	aResource getHandle isNull ifTrue: [ ^ self ].
	self deleteExternalResource: aResource.
	aResource getHandle beNull
]

{ #category : #'external resource management' }
TFAutoReleasableResource >> beNull [

	self getHandle beNull
]

{ #category : #'external resource management' }
TFAutoReleasableResource >> resourceData [

	^ self
]
