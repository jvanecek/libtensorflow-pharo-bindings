Class {
	#name : #TFSession,
	#superclass : #FFIOpaqueObject,
	#category : #TensorFlowCore
}

{ #category : #'instance creation' }
TFSession class >> finalizeResourceData: handle [
	| status |
	handle isNull
		ifTrue: [ ^ self ].
	status := TFStatus create.
	(TensorFlowCAPI current) closeSession: handle status: status.
	status check.
	status := TFStatus create.
	(TensorFlowCAPI current) deleteSession: handle status: status.
	status check
]

{ #category : #'instance creation' }
TFSession class >> on: aTF_Graph [
	| options status answer session |
	options := TFSessionOptions create.
	status := TFStatus create.
	answer := TensorFlowCAPI current newSession: aTF_Graph options: options status: status.
	status check.
	session := answer autoRelease.
	aTF_Graph initializeOn:session.
	^ session
]

{ #category : #release }
TFSession >> close [
"deprecated"
	| status |
	status := TFStatus create.
	self library closeSession: self status: status.
	status check
]

{ #category : #release }
TFSession >> library [
	^ TensorFlowCAPI current
]

{ #category : #running }
TFSession >> run [
	| status |
	status := TFStatus create.
	self library
		runSession: self
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: nil
		values: nil
		count: 0
		targets: nil
		count: 0
		metadata: nil
		status: status.
	status check
]

{ #category : #running }
TFSession >> runInputs: inArrayOfTFInputs values: inArrayOfTFTensor outputs: outArrayOfTFOutputs [
	| inputs invalues outputs outvalues status |
	status := TFStatus create.
	inputs := TFInputArray fromCollection: inArrayOfTFInputs.
	invalues := TFTensorPtrArray fromCollection: inArrayOfTFTensor.
	outputs := TFOutputArray externalFromArray: outArrayOfTFOutputs.
	outvalues := TFTensorPtrArray externalNew: outArrayOfTFOutputs size.
	
	self library
		runSession: self
		options: nil
		inputs: inputs getHandle
		values: invalues getHandle
		count: inArrayOfTFInputs size
		outputs: outputs getHandle
		values: outvalues getHandle
		count: outArrayOfTFOutputs size
		targets: nil
		count: 0
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #running }
TFSession >> runOperation: aTFOperation [
	^ self runOperations: (Array with: aTFOperation)
]

{ #category : #running }
TFSession >> runOperation: aTFOperation input: inTFOutputOrInput value: inTFTensor output: outTFTOutput [
	| inputs invalues operations outputs outvalues tensor |
	inputs := Array with: inTFOutputOrInput.
	invalues := Array with: inTFTensor.
	outputs := Array with: outTFTOutput.
	operations := Array with: aTFOperation.
	outvalues := self
		runOperations: operations
		inputs: inputs
		values: invalues
		outputs: outputs.
	tensor := outvalues first.
	^ tensor
]

{ #category : #running }
TFSession >> runOperation: aTFOperation output: aTFOutput [
	| operations answer outputs |
	operations := TFOperationPtrArray externalNew: 1.
	outputs := TFOutputArray externalNew: 1.
	outputs at:1 put: aTFOutput.
	operations at:1 put: aTFOperation getHandle getHandle.
	answer := self runOperations: operations outputs: outputs size: 1.
	^ answer first
]

{ #category : #running }
TFSession >> runOperations: anArrayOfTFOperations [

	| status operations |

	status := TFStatus create.
	operations := TFOperationPtrArray
		fromCollection: ( anArrayOfTFOperations collect: [ :op | op getHandle getHandle ] ).
	self library
		runSession: self
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: nil
		values: nil
		count: 0
		targets: operations getHandle
		count: anArrayOfTFOperations size
		metadata: nil
		status: status.
	status check
]

{ #category : #running }
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

{ #category : #running }
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

{ #category : #running }
TFSession >> runOutput: aTFOutput [
	| results |
	results := self runOutputs: {aTFOutput}.
	^ results first
]

{ #category : #running }
TFSession >> runOutputs: anArrayOfTFOutputs [
	| outputs |
	outputs := TFOutputArray fromCollection: anArrayOfTFOutputs.
	^ self runOutputs: outputs size: anArrayOfTFOutputs size
]

{ #category : #running }
TFSession >> runOutputs: aTFOutputArray size: anInteger [
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
		targets: nil
		count: 0
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]
