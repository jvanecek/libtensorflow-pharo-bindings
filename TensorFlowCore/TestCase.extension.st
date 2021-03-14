Extension { #name : #TestCase }

{ #category : #'*TensorFlowCore' }
TestCase >> assert: expected closeTo: actual [
	self assert: (expected closeTo: actual) description: (self comparingStringBetween: expected and: actual)
]
