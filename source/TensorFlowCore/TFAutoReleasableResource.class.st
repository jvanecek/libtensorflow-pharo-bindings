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
TFAutoReleasableResource class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	self deleteExternalResource: handle
	
]

{ #category : #'external resource management' }
TFAutoReleasableResource >> resourceData [

	^ self
]
