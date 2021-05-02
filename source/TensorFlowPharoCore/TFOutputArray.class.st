Class {
	#name : #TFOutputArray,
	#superclass : #FFIExternalArray,
	#category : #TensorFlowPharoCore
}

{ #category : #accessing }
TFOutputArray class >> externalFromArray: anArray [
	| answer |
	answer := self externalNew: anArray size.
	1 to: anArray size do: [:i |
		answer at: i put: (anArray at: i)].
	^ answer
]

{ #category : #accessing }
TFOutputArray class >> externalNew: aNumberOfOutput [

^ self externalNewType: self type size: aNumberOfOutput
]

{ #category : #accessing }
TFOutputArray class >> fromCollection: aCollection [
|answer|
answer := self externalNewType: self type size: aCollection size.
aCollection withIndexDo: [ :each :index | answer at: index put: each ].
^answer
]

{ #category : #accessing }
TFOutputArray class >> type [
	^ TFOutput
]

{ #category : #accessing }
TFOutputArray >> at: index put: aTFOutput [

	^ super at: index put: aTFOutput withNormalizedHandle
]

{ #category : #'as yet unclassified' }
TFOutputArray >> withNormalizedHandle [

	^ self
]
