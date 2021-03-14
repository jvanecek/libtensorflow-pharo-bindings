Class {
	#name : #DeterministicSeedTensorGenerator,
	#superclass : #PseudorandomTensorGenerator,
	#instVars : [
		'seed'
	],
	#category : 'TFVariableSpecificationModel'
}

{ #category : #'Instance Creation' }
DeterministicSeedTensorGenerator class >> fixedTo: anIntegerSeed [

	^self new initializeFixedTo: anIntegerSeed
]

{ #category : #Initialization }
DeterministicSeedTensorGenerator >> initializeFixedTo: anIntegerSeed [

	seed := anIntegerSeed
]

{ #category : #Accessing }
DeterministicSeedTensorGenerator >> truncatedNormalTensorOn: aGraph shaped: aTensorShape [

	| shape seeds |

	shape := aGraph const: aTensorShape dimensionSizes asInt32Tensor.
	seeds := aGraph const: (Array with: seed with: 0) asInt32Tensor.
	^shape
		binaryOp: 'StatelessTruncatedNormal'
		with: seeds
		described: [:description | description atDataTypePut: TFTensor typeFloat]
]

{ #category : #Accessing }
DeterministicSeedTensorGenerator >> uniformTensorOn: aGraph shaped: aTensorShape [

	| shape seeds |

	shape := aGraph const: aTensorShape dimensionSizes asInt32Tensor.
	seeds := aGraph const: (Array with: seed with: 0) asInt32Tensor.
	^shape
		binaryOp: 'StatelessRandomUniform'
		with: seeds
		described: [:description | description atDataTypePut: TFTensor typeFloat]
]
