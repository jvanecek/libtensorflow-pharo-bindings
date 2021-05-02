Class {
	#name : #TFOperationPtrArray,
	#superclass : #FFIExternalArray,
	#category : #TensorFlowPharoCore
}

{ #category : #'instance creation' }
TFOperationPtrArray class >> externalNew: aNumberOfOperation [

^ self externalNewType: self type size: aNumberOfOperation
]

{ #category : #'instance creation' }
TFOperationPtrArray class >> fromCollection: aCollection [
|answer|
answer := self externalNewType: self type size: aCollection size.
aCollection withIndexDo: [ :each :index | answer at: index put: each ].
^answer
]

{ #category : #'instance creation' }
TFOperationPtrArray class >> type [

	^ 'TFOperation*'
]

{ #category : #converting }
TFOperationPtrArray >> asArray [
|answer|
answer := Array new: self size.
self withIndexDo: [ :each :index | answer at: index put: (TFOperation fromHandle: each) ].
^answer
]
