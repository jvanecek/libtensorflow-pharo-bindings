Extension { #name : #TFSession }

{ #category : #'*LibTensorFlow-Deprecated' }
TFSession >> delete [
| status |
"deprecated"
self halt.
	self ignoreFinalization.
	self isNull ifFalse: [
		self close.
		status := TFStatus create.
		self library
			deleteSession: self
			status: status.
		status check.
	].
	handle := nil.

]
