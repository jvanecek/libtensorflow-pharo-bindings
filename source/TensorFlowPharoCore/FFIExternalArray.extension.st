Extension { #name : #FFIExternalArray }

{ #category : #'*TensorFlowPharoCore' }
FFIExternalArray class >> externalNewType: aType fromArray: anArray [
	| answer |
	answer := self externalNewType: aType size: anArray size.
	anArray withIndexDo: [ :each :index | answer at: index put: each ].
	^ answer
]
