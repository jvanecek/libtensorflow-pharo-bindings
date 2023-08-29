Class {
	#name : #BatchDataset,
	#superclass : #DatasetComputationAware,
	#instVars : [
		'outputDomains',
		'currentComputation'
	],
	#category : #TensorFlowDatasetModel
}

{ #category : #'Instance Creation' }
BatchDataset class >> splitting: aDataset in: aBatchSize [

	^self new initializeSplitting: aDataset in: aBatchSize
]

{ #category : #Accessing }
BatchDataset >> currentComputation [

	^currentComputation
]

{ #category : #Initialization }
BatchDataset >> initializeSplitting: aDataset in: aBatchSize [

	currentComputation := aDataset currentComputation.
	outputDomains := aDataset outputDomains collect: #withUnknowBatchDimension.
	value := currentComputation
		newOperationOf: 'BatchDatasetV2'
		namePrefixed: 'BatchDataset'
		withAll: ( Array with: aDataset with: aBatchSize asInt64Tensor with: self shouldDropRemainingBatch )
		describedBy: [ :description | 
			description
				atOutputTypesPut: ( outputDomains collect: #type );
				atOutputShapesPut: ( outputDomains collect: #shape )
			]
]

{ #category : #Accessing }
BatchDataset >> outputDomains [

	^outputDomains
]

{ #category : #Accessing }
BatchDataset >> shouldDropRemainingBatch [

	"A scalar representing whether the last batch should be dropped in case its size is smaller than desired."

	^ false asBooleanTensor
]
