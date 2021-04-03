Extension { #name : #TFSession }

{ #category : #'*TensorFlowDeprecatedCore' }
TFSession >> runOperation: aTFOperation output: aTFOutput [
	| operations answer outputs |
	operations := TFOperationPtrArray externalNew: 1.
	outputs := TFOutputArray externalNew: 1.
	outputs at:1 put: aTFOutput.
	operations at:1 put: aTFOperation getHandle getHandle.
	answer := self runOperations: operations outputs: outputs size: 1.
	^ answer first
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFSession >> runOperations: anArrayOfTFOperations inputs: inArrayOfTFOutputs values: inArrayOfTFTensor outputs: outArrayOfTFOutputs [

	| operations inputs invalues outputs outvalues status |

	status := TFStatus create.
	operations := TFOperationPtrArray
		fromCollection: ( anArrayOfTFOperations collect: [ :op | op getHandle getHandle ] ).
	inputs := TFOutputArray fromCollection: inArrayOfTFOutputs.
	invalues := TFTensorPtrArray fromCollection: inArrayOfTFTensor.
	outputs := TFOutputArray fromCollection: outArrayOfTFOutputs.
	outvalues := TFTensorPtrArray externalNew: outArrayOfTFOutputs size.
	self library
		runSession: self
		options: nil
		inputs: inputs getHandle
		values: invalues
		count: inArrayOfTFOutputs size
		outputs: outputs getHandle
		values: outvalues
		count: outArrayOfTFOutputs size
		targets: operations getHandle
		count: anArrayOfTFOperations size
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFSession >> runOperations: aTFOperationArray outputs: aTFOutputArray size: anInteger [
	| status outvalues |
	status := TFStatus create.
	outvalues := TFTensorPtrArray externalNew: anInteger.
	self library
		runSession: self
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: aTFOutputArray getHandle
		values: outvalues getHandle
		count: anInteger
		targets: aTFOperationArray getHandle
		count: 1
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #'*TensorFlowDeprecatedCore' }
TFSession >> runOutput: aTFOutput [
	| results |
	results := self runOutputs: {aTFOutput}.
	^ results first
]
