Extension { #name : #TFSession }

{ #category : #'*TensorFlowDeprecatedCore' }
TFSession >> runOperation: aTFOperation output: aTFOutput [

	^ self library runSession: self operation: aTFOperation output: aTFOutput
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFSession >> runOutput: aTFOutput [
	| results |
	results := self runOutputs: {aTFOutput}.
	^ results first
]
