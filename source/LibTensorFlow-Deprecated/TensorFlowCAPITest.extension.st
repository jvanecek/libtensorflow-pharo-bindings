Extension { #name : #TensorFlowCAPITest }

{ #category : #'*LibTensorFlow-Deprecated' }
TensorFlowCAPITest >> testAttrSetStrings [
	"self assert: false description: 'DebugIdentity operation does not exist anymore in TF r1.7'.
	self testAttrSetStrings: #('file://tmp/TFDebug.log').
	self testAttrSetStrings: #('file://tmp/TFDebug.log' 'file://tmp/TFDebug.2.log')"
]

{ #category : #'*LibTensorFlow-Deprecated' }
TensorFlowCAPITest >> testNewGraph [
	"Comment because #delete is deprecated 
	| graph |
	graph := TFGraph create.
	self deny: graph isNull.
	graph delete.
	self assert: graph isNull"
]

{ #category : #'*LibTensorFlow-Deprecated' }
TensorFlowCAPITest >> testSessionDeletionDoesntDeleteGraphs [
	"| session graph allocatedObjects |
	graph := TFGraph create.
	session := TFSession on: graph.
	session ignoreFinalization.
	session close.
	session delete.

	 Allocate some external objects using the library, if the graph was released, we expect its space to be reused 
	allocatedObjects := OrderedCollection new: 10.
	10 timesRepeat: [ allocatedObjects add: TFStatus create ].
	self
		shouldnt: [ graph placeholder: 'a' type: TFTensor typeInt64 ]
		raise: Error
		description: 'The FFI call would crash if the graph was released by deleting the session'"
]
