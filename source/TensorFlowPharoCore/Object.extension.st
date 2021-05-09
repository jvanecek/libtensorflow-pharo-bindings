Extension { #name : #Object }

{ #category : #'*TensorFlowPharoCore' }
Object >> byteSize [

^8
]

{ #category : #'*TensorFlowPharoCore' }
Object >> ignoreFinalization [
	self finalizationRegistry remove: self ifAbsent: [  ]
]

{ #category : #'*TensorFlowPharoCore' }
Object >> useFinalization [
	self finalizationRegistry add: self
]
