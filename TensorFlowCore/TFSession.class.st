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
TFSession >> runInputs: inArrayOfTF_Inputs values: inArrayOfTF_Tensor outputs: outArrayOfTF_Outputs [
	| inputs invalues outputs outvalues status |
	status := TFStatus create.
	inputs := TFInputArray fromCollection: inArrayOfTF_Inputs.
	invalues := TFTensorPtrArray fromCollection: inArrayOfTF_Tensor.
	outputs := TFOutputArray externalFromArray: outArrayOfTF_Outputs.
	outvalues := TFTensorPtrArray externalNew: outArrayOfTF_Outputs size.
	
	self library
		runSession: self
		options: nil
		inputs: inputs getHandle
		values: invalues getHandle
		count: inArrayOfTF_Inputs size
		outputs: outputs getHandle
		values: outvalues getHandle
		count: outArrayOfTF_Outputs size
		targets: nil
		count: 0
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #running }
TFSession >> runOperation: aTF_Operation [
	^ self runOperations: (Array with: aTF_Operation)
]

{ #category : #running }
TFSession >> runOperation: aTF_Operation input: inTF_OutputOrInput value: inTF_Tensor output: outTF_Output [
	| inputs invalues operations outputs outvalues tensor |
	inputs := Array with: inTF_OutputOrInput.
	invalues := Array with: inTF_Tensor.
	outputs := Array with: outTF_Output.
	operations := Array with: aTF_Operation.
	outvalues := self
		runOperations: operations
		inputs: inputs
		values: invalues
		outputs: outputs.
	tensor := outvalues first.
	^ tensor
]

{ #category : #running }
TFSession >> runOperation: aTF_Operation output: aTF_Output [
	| operations answer outputs |
	operations := TFOperationPtrArray externalNew: 1.
	outputs := TFOutputArray externalNew: 1.
	outputs at:1 put: aTF_Output.
	operations at:1 put: aTF_Operation getHandle getHandle.
	answer := self runOperations: operations outputs: outputs size: 1.
	^ answer first
]

{ #category : #running }
TFSession >> runOperations: anArrayOfOperations [

	| status operations |

	status := TFStatus create.
	operations := TFOperationPtrArray
		fromCollection: ( anArrayOfOperations collect: [ :op | op getHandle getHandle ] ).
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
		count: anArrayOfOperations size
		metadata: nil
		status: status.
	status check
]

{ #category : #running }
TFSession >> runOperations: anArrayOfOperations inputs: inArrayOfTF_Outputs values: inArrayOfTF_Tensor outputs: outArrayOfTF_Outputs [

	| operations inputs invalues outputs outvalues status |

	status := TFStatus create.
	operations := TFOperationPtrArray
		fromCollection: ( anArrayOfOperations collect: [ :op | op getHandle getHandle ] ).
	inputs := TFOutputArray fromCollection: inArrayOfTF_Outputs.
	invalues := TFTensorPtrArray fromCollection: inArrayOfTF_Tensor.
	outputs := TFOutputArray fromCollection: outArrayOfTF_Outputs.
	outvalues := TFTensorPtrArray externalNew: outArrayOfTF_Outputs size.
	self library
		runSession: self
		options: nil
		inputs: inputs getHandle
		values: invalues
		count: inArrayOfTF_Outputs size
		outputs: outputs getHandle
		values: outvalues
		count: outArrayOfTF_Outputs size
		targets: operations getHandle
		count: anArrayOfOperations size
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #running }
TFSession >> runOperations: aTF_OperationArray outputs: aTF_OutputArray size: anInteger [
	| status outvalues |
	status := TFStatus create.
	outvalues := TFTensorPtrArray externalNew: anInteger.
	self library
		runSession: self
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: aTF_OutputArray getHandle
		values: outvalues getHandle
		count: anInteger
		targets: aTF_OperationArray getHandle
		count: 1
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]

{ #category : #running }
TFSession >> runOutput: aTF_Output [
	| results |
	results := self runOutputs: {aTF_Output}.
	^ results first
]

{ #category : #running }
TFSession >> runOutputs: anArrayOfTF_Outputs [
	| outputs |
	outputs := TFOutputArray fromCollection: anArrayOfTF_Outputs.
	^ self runOutputs: outputs size: anArrayOfTF_Outputs size
]

{ #category : #running }
TFSession >> runOutputs: aTF_OutputArray size: anInteger [
	| status outvalues |
	status := TFStatus create.
	outvalues := TFTensorPtrArray externalNew: anInteger.
	self library
		runSession: self
		options: nil
		inputs: nil
		values: nil
		count: 0
		outputs: aTF_OutputArray getHandle
		values: outvalues getHandle
		count: anInteger
		targets: nil
		count: 0
		metadata: nil
		status: status.
	status check.
	^ outvalues asArray
]
