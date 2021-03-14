Extension { #name : #Object }

{ #category : #'*TensorFlowCore' }
Object >> byteSize [

^8
]

{ #category : #'*TensorFlowCore' }
Object >> ignoreFinalization [
	self finalizationRegistry remove: self ifAbsent: [  ]
]

{ #category : #'*TensorFlowCore' }
Object >> useFinalization [
	self finalizationRegistry add: self
]
