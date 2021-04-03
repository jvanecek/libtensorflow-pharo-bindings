Class {
	#name : #TensorFlowComputation,
	#superclass : #Object,
	#instVars : [
		'graph',
		'session'
	],
	#category : 'TensorFlowEnvironmentModel'
}

{ #category : #'Instance Creation' }
TensorFlowComputation class >> new [

	^self on: TFGraph create
]

{ #category : #'Instance Creation' }
TensorFlowComputation class >> on: aTFGraph [

	^super new initializeOn: aTFGraph
]

{ #category : #Computing }
TensorFlowComputation >> compute: anOperation [

	^self compute: anOperation feedingInputsWith: Dictionary new
]

{ #category : #Computing }
TensorFlowComputation >> compute: anOperation feedingInputsWith: aPlaceholderValueMapping [

	^(self computeAll: (Array with: anOperation) feedingInputsWith: aPlaceholderValueMapping)
		at: anOperation
]

{ #category : #Computing }
TensorFlowComputation >> computeAll: operations feedingInputsWith: aPlaceholderValueMapping [

	| inputPlaceholders inputValues outputs results resultsByName |

	inputPlaceholders := OrderedCollection new.
	inputValues := OrderedCollection new.
	aPlaceholderValueMapping keysAndValuesDo: [:placeholderName :value |
		inputPlaceholders add: (graph operationNamed: placeholderName) firstInput.
		inputValues add: value].

	outputs := operations collect: [:operation | operation outputOn: graph].

	results :=
		self
			createSessionAndCompute: outputs asArray
			feeding: inputPlaceholders asArray
			with: inputValues asArray.

	resultsByName := Dictionary new.
	operations
		doWithIndex: [:operation :index | resultsByName at: operation put: (results at: index)].
	^resultsByName
]

{ #category : #Computing }
TensorFlowComputation >> computeAllNamed: anOperationsName feedingInputsWith: aPlaceholderValueMapping [

	| inputPlaceholders inputValues outputs results resultsByName |

	inputPlaceholders := OrderedCollection new.
	inputValues := OrderedCollection new.
	aPlaceholderValueMapping keysAndValuesDo: [:placeholderName :value |
		inputPlaceholders add: (graph operationNamed: placeholderName) firstInput.
		inputValues add: value].

	outputs :=
		anOperationsName
			collect: [:operationName | (graph operationNamed: operationName) firstOutput].

	results :=
		self
			createSessionAndCompute: outputs asArray
			feeding: inputPlaceholders asArray
			with: inputValues asArray.

	resultsByName := Dictionary new.
	anOperationsName
		doWithIndex: [:outputName :index | resultsByName at: outputName put: (results at: index)].
	^resultsByName
]

{ #category : #Computing }
TensorFlowComputation >> createSessionAndCompute: anArrayOfOutputs feeding: anArrayOfPlaceholders with: anArrayOfInputs [

	session ifNil: [
		session := TFSession on: graph.
		"When initialize graph, we initialize also the variables. So this can't be done before the variables are created, 
		 and can't be done every time we call run, because will be overriding them every time with the initial value. 
		 This is the best place I cound found to do it." 
		graph initializeOn: session].

	^session runInputs: anArrayOfPlaceholders values: anArrayOfInputs outputs: anArrayOfOutputs
]

{ #category : #Computing }
TensorFlowComputation >> gradientsOf: aFunctionCollection withRespectTo: aVariableCollection product: aCotangentVectors [

	| vectorOutputs |

	vectorOutputs :=
		aCotangentVectors
			ifNil: [nil]
			ifNotNil: [aCotangentVectors collect: [:var | var outputOn: graph]].

	^graph
		gradientsOf: (aFunctionCollection collect: [:function | function outputOn: graph])
		withRespectTo: (aVariableCollection collect: [:var | var outputOn: graph])
		product: vectorOutputs
]

{ #category : #Accessing }
TensorFlowComputation >> inScopeNamed: aScopeName do: aBlock [

	^graph inScopeNamed: aScopeName do: aBlock
]

{ #category : #Initialization }
TensorFlowComputation >> initializeOn: aGraph [

	graph := aGraph
]

{ #category : #'Creating - Operations' }
TensorFlowComputation >> newOperationOf: anOperationType namePrefixed: anOperationName with: aTFNode [

	^self
		newOperationOf: anOperationType
		namePrefixed: anOperationName
		withAll: (Array with: aTFNode)
		describedBy: [:desc | ]
]

{ #category : #'Creating - Operations' }
TensorFlowComputation >> newOperationOf: anOperationType namePrefixed: anOperationName with: aTFNode with: anotherTFNode [

	^self
		newOperationOf: anOperationType
		namePrefixed: anOperationName
		withAll: (Array with: aTFNode with: anotherTFNode)
		describedBy: [:desc | ]
]

{ #category : #'Creating - Operations' }
TensorFlowComputation >> newOperationOf: anOperationType namePrefixed: anOperationName withAll: graphNodes describedBy: aBlock [

	^graph
		newOperation: anOperationType
		named: (graph nameFor: anOperationName)
		described: [:description |
			graphNodes do: [:node | description addInput: (node outputOn: graph)].
			aBlock value: description]
]

{ #category : #'Creating - Operations' }
TensorFlowComputation >> newOperationOf: anOperationType namePrefixed: anOperationName withList: aTFNodeCollection [

	^graph
		newOperation: anOperationType
		named: (graph nameFor: anOperationName)
		described: [:description |
			description addInputs: (aTFNodeCollection collect: [:node | node outputOn: graph])]
]

{ #category : #Accessing }
TensorFlowComputation >> operationNamed: aName [

	^self
		withOperationNamed: aName
		do: [:op | ^op]
		ifNone: [self error: (#'Operation named <1p> not found in the graph' expandMacrosWith: aName)]
]

{ #category : #Accessing }
TensorFlowComputation >> withOperationNamed: aName do: aBlock ifNone: aNoneBlock [


	^graph operationNamed: aName ifFound: aBlock ifNotFound: aNoneBlock
]