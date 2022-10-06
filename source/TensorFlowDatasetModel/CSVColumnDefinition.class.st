Class {
	#name : #CSVColumnDefinition,
	#superclass : #Object,
	#instVars : [
		'definition'
	],
	#category : #TensorFlowDatasetModel
}

{ #category : #'Instance Creation' }
CSVColumnDefinition class >> containing: aTensor [

	^self new initializeContaining: aTensor
]

{ #category : #'Instance Creation' }
CSVColumnDefinition class >> mandatoryTyped: aTensorType [

	^ self containing: (TFTensor newTyped: aTensorType containing: #(  ))
]

{ #category : #'Instance Creation' }
CSVColumnDefinition class >> nullableTyped: aTensorType defaultTo: aDefaultValue [

	^ self containing: (TFTensor
			   newTyped: aTensorType
			   containing: (Array with: aDefaultValue))
]

{ #category : #Accessing }
CSVColumnDefinition >> columnDomain [

	^TensorDomain of: definition type withShape: TensorShape scalar
]

{ #category : #Initialization }
CSVColumnDefinition >> initializeContaining: aTensor [

	definition := aTensor
]

{ #category : #Converting }
CSVColumnDefinition >> outputOn: aTensorFlowComputation [

	^(ConstantNode on: aTensorFlowComputation named: 'Const' with: definition) value firstOutput
]
