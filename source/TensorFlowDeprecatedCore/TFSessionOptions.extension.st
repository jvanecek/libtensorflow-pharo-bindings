Extension { #name : #TFSessionOptions }

{ #category : #'*TensorFlowDeprecatedCore' }
TFSessionOptions >> delete [
"deprecated"
self halt.

	self ignoreFinalization.
	self isNull ifFalse: [
		self library deleteSessionOptions: self].
	handle := nil
]
