Class {
	#name : #ShapeOperation,
	#superclass : #TensorFlowOperationAbstract,
	#instVars : [
		'tensor'
	],
	#category : #TensorFlowOperationMathModel
}

{ #category : #'Instance Creation' }
ShapeOperation class >> named: anOperationName of: anOperationNode [

	^self new initializeNamed: anOperationName of: anOperationNode
]

{ #category : #'Instance Creation' }
ShapeOperation class >> of: anOperationNode [

	^self named: self operationType of: anOperationNode
]

{ #category : #Accessing }
ShapeOperation class >> operationType [

	^'Shape'
]

{ #category : #accessing }
ShapeOperation >> batchDimension [

	^ self currentComputation
		newOperationOf: 'Slice'
		namePrefixed: 'Slice'
		withAll: (Array with: self with: #(0) asInt32Tensor with: #(1) asInt32Tensor)
		describedBy: [ :desc |  ]
]

{ #category : #Accessing }
ShapeOperation >> currentComputation [

	^tensor currentComputation
]

{ #category : #accessing }
ShapeOperation >> flattenedDimensionSize [
	^ self currentComputation
		newOperationOf: 'Prod'
		namePrefixed: 'Prod'
		withAll:
			{self nonBatchDimensions.
			#(0) asInt32Tensor}
		describedBy: [ :description |  ]
]

{ #category : #accessing }
ShapeOperation >> flattenedShape [
	| flattenedDimesionAsVector flattenShape |
	flattenedDimesionAsVector := self currentComputation
		newOperationOf: 'ExpandDims'
		namePrefixed: 'ExpandDim'
		withAll:
			{self flattenedDimensionSize.
			#(0) asInt32Tensor}
		describedBy: [ :desc |  ].
	flattenShape := {self batchDimension.
	flattenedDimesionAsVector}.
	^ self currentComputation
		newOperationOf: 'Concat'
		namePrefixed: 'Concat'
		withAll: #()
		describedBy: [ :description | 
			description
				addInput: (0 asInt32Tensor outputOn: self currentComputation);
				addInputs: (flattenShape collect: [ :d | d outputOn: self currentComputation ]) ]
]

{ #category : #Initialization }
ShapeOperation >> initializeNamed: anOperationName of: anOperationNode [

	tensor := anOperationNode.
	value :=
		self currentComputation
			newOperationOf: self class operationType
			namePrefixed: anOperationName
			with: anOperationNode
]

{ #category : #accessing }
ShapeOperation >> nonBatchDimensions [

	^ self currentComputation
		newOperationOf: 'Slice'
		namePrefixed: 'Slice'
		withAll: (Array with: self with: #(1) asInt32Tensor with: #(-1) asInt32Tensor)
		describedBy: [ :desc |  ]
]
