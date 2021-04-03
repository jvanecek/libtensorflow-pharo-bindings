Class {
	#name : #TensorFlowCAPISlowTests,
	#superclass : #TestCase,
	#category : #TensorFlowCoreTests
}

{ #category : #accessing }
TensorFlowCAPISlowTests class >> defaultTimeLimit [

	^ 15 minutes
]

{ #category : #'testing session' }
TensorFlowCAPISlowTests >> assertCreating: anAmount of: aTensorFlowObjectCreator releasesExternalMemoryRepeatingUpTo: timesRepeat [

	| total handles |

	total := 0.
	handles := Set new.
	timesRepeat timesRepeat: [
		total := total + anAmount.
		handles addAll: (
			(1 to: anAmount) collect: [:i |
				Smalltalk garbageCollect.
				aTensorFlowObjectCreator value getHandle getHandle ]).
		handles size < total ifTrue: [
			" Meaning some external addresses where reused, so we're good "
			^self]].
	self 
		assert: handles size < total
		description: 'No external address could be reused, check for some leak'
	
]

{ #category : #'testing graph' }
TensorFlowCAPISlowTests >> testGraphFinalizationReleasesExternalMemory [

	self
		assertCreating: 10
		of: [ TFGraph create useFinalization ]
		releasesExternalMemoryRepeatingUpTo: 20
]

{ #category : #'testing tensor' }
TensorFlowCAPISlowTests >> testRunGraphMulTwoInputsConstTensorDeleted [
	self skip. " Skip this tests because its breaking the image"
	
	"| graph inputs inputValues mul output session results |
	graph := self mulGraphTwoInputsInt64ConstTensorDeleted.
	inputs := Array with: ((graph operationNamed: 'in1') input: 0) with: ((graph operationNamed: 'in2') input: 0).
	inputValues := Array with: (TFTensor fromInt64: 16r23) with: (TFTensor fromInt64: 16r24).
	Smalltalk garbageCollect.
	(TFTensor fromInt64: 16r1234123412341234) useFinalization.
	Smalltalk garbageCollect.
	mul := graph operationNamed: 'mul2'.
	output := mul output: 0.
	session := TFSession on: graph.
	results := session
		runOperations: (Array with: mul)
		inputs: inputs
		values: inputValues
		outputs: (Array with: output).
	self deny: results isNull.
	self deny: results first isNull.
	self deny: results first data isNull.
	self assert: (results first data getHandle signedLongLongAt: 1) equals: (16r2121212121212121 * 16r23 * 16r24 bitAnd: 16rFFFFFFFFFFFFFFFF).
	graph delete."

]

{ #category : #'testing tensor' }
TensorFlowCAPISlowTests >> testRunGraphMulTwoInputsConstTensorDeletedManyTimes [
	20 timesRepeat: [ self testRunGraphMulTwoInputsConstTensorDeleted ]
]

{ #category : #'testing session' }
TensorFlowCAPISlowTests >> testSessionFinalizationReleasesExternalMemory [

	| graph |

	graph := TFGraph create.
	self assertCreating: 20 of: [ TFSession on: graph ] releasesExternalMemoryRepeatingUpTo: 20
]

{ #category : #'testing options' }
TensorFlowCAPISlowTests >> testSessionOptionFinalizationReleasesExternalMemory [

	self assertCreating: 10 of: [ TFSessionOptions create ] releasesExternalMemoryRepeatingUpTo: 20
]

{ #category : #'testing status' }
TensorFlowCAPISlowTests >> testStatusFinalizationReleasesExternalMemory [

	self assertCreating: 11 of: [ TFStatus create ] releasesExternalMemoryRepeatingUpTo: 1
]

{ #category : #'testing tensor' }
TensorFlowCAPISlowTests >> testTensorFinalizationReleasesExternalMemory [

	| template |

	template := {( String new: 10 ).
	( String new: 100 ).
	( String new: 1000 )}.
	self
		assertCreating: 20
		of: [ TFTensor fromStringArray: template ]
		releasesExternalMemoryRepeatingUpTo: 20
]
