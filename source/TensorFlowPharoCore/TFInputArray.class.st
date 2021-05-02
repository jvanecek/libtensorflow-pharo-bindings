"
An array of TF_Input structure
"
Class {
	#name : #TFInputArray,
	#superclass : #FFIExternalArray,
	#category : #TensorFlowPharoCore
}

{ #category : #accessing }
TFInputArray class >> externalNew: aNumberOfInput [

	^ self externalNewType: self type size: aNumberOfInput
]

{ #category : #accessing }
TFInputArray class >> fromCollection: aCollection [
	| answer |
	answer := self externalNew: aCollection size.
	aCollection withIndexDo: [ :each :index | answer at: index put: each].
	^ answer
]

{ #category : #accessing }
TFInputArray class >> type [
	^ TFInput
]
