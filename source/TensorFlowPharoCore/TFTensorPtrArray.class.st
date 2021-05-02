Class {
	#name : #TFTensorPtrArray,
	#superclass : #FFIExternalArray,
	#category : #TensorFlowPharoCore
}

{ #category : #accessing }
TFTensorPtrArray class >> externalNew: aNumberOfTensor [

^ self externalNewType: self type size: aNumberOfTensor
]

{ #category : #accessing }
TFTensorPtrArray class >> fromCollection: aCollection [
|answer|
answer := self externalNewType: self type size: aCollection size.
aCollection withIndexDo: [ :each :index | answer at: index put: each getHandle].
^answer
]

{ #category : #accessing }
TFTensorPtrArray class >> type [

^'TFTensor*'
]

{ #category : #converting }
TFTensorPtrArray >> asArray [
|answer|
answer := Array new: self size.
self withIndexDo: [ :each :index | answer at: index put: (TFTensor fromHandle: each) ].
^answer
]

{ #category : #accessing }
TFTensorPtrArray >> numbersAt: index [
	| tensor |
	tensor := self at: index.
	^ tensor asNumbers
]
