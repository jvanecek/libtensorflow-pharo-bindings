Class {
	#name : #TFSession,
	#superclass : #FFIOpaqueObject,
	#category : #TensorFlowCore
}

{ #category : #'instance creation' }
TFSession class >> finalizeResourceData: handle [

	handle isNull
		ifTrue: [ ^ self ].
	TensorFlowCAPI current closeSession: handle.
	TensorFlowCAPI current deleteSession: handle
]

{ #category : #'instance creation' }
TFSession class >> on: aTFGraph [

	^ TensorFlowCAPI current newAutoreleaseSessionOn: aTFGraph
]

{ #category : #release }
TFSession >> close [
	" deprecated "
	self library closeSession: self
]

{ #category : #release }
TFSession >> library [
	^ TensorFlowCAPI current
]

{ #category : #running }
TFSession >> run [

	self library runSession: self
]

{ #category : #running }
TFSession >> runInputs: inArrayOfTFInputs values: inArrayOfTFTensor outputs: outArrayOfTFOutputs [
	
	^ self library runSession: self inputs: inArrayOfTFInputs values: inArrayOfTFTensor outputs: outArrayOfTFOutputs
]

{ #category : #running }
TFSession >> runOperation: aTFOperation [
	^ self runOperations: (Array with: aTFOperation)
]

{ #category : #release }
TFSession >> runOperations: anArrayOfTFOperations [

	^ self library runSession: self operations: anArrayOfTFOperations
]

{ #category : #running }
TFSession >> runOutputs: anArrayOfTFOutputs [
	
	^self library runSession: self outputs: anArrayOfTFOutputs
]
