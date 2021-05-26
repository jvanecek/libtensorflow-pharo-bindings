Class {
	#name : #TensorFlowTestCase,
	#superclass : #TestCase,
	#category : #TensorFlowCoreTests
}

{ #category : #Asserting }
TensorFlowTestCase >> assert: aNumber closeTo: anotherNumber [
	^ self
		assert: (self number: aNumber isCloseTo: anotherNumber)
		description: anotherNumber printString, ' was expected to be close to ', aNumber printString.

]

{ #category : #Asserting }
TensorFlowTestCase >> assertAll: aCollection closeTo: anotherCollection [
	^ aCollection with: anotherCollection do: [:a :b | self assert: a closeTo: b]
]

{ #category : #Accessing }
TensorFlowTestCase >> garbageCollect [

	Smalltalk garbageCollect
]

{ #category : #Asserting }
TensorFlowTestCase >> number: aNumber isCloseTo: anotherNumber [
 	"are these two numbers close?"
	self = 0.0 ifTrue: [^anotherNumber abs < 0.0001].
	anotherNumber = 0 ifTrue: [^aNumber abs < 0.0001].
	^aNumber = anotherNumber asFloat
		or: [(aNumber - anotherNumber) abs / (aNumber abs max: anotherNumber abs) < 0.0001]
]

{ #category : #Asserting }
TensorFlowTestCase >> should: aBlock raiseError: aString [
	| message |
	message := 'No Error was signaled'.
	aBlock on: Error do: [ :error | message := error messageText ].
	self assert: aString isEqualSkippingSeparatorsTo: message.
]

{ #category : #Asserting }
TensorFlowTestCase >> shouldnt: aBlock raise: anExceptionalEvent [
	aBlock value.
	self assert: true.
]

{ #category : #Asserting }
TensorFlowTestCase >> shouldnt: aBlock raise: anExceptionalEvent description: aString [
	[aBlock value] on: Error do: [self assert: false description: aString]
]
