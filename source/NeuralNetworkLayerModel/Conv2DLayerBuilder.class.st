Class {
	#name : #Conv2DLayerBuilder,
	#superclass : #Object,
	#instVars : [
		'filters',
		'kernelShape',
		'input',
		'activation',
		'kernelInitializer',
		'inputSize',
		'inputSizeAsserter'
	],
	#category : #NeuralNetworkLayerModel
}

{ #category : #'instance creation' }
Conv2DLayerBuilder class >> ofSize: aFilter kernelSized: aTensorShape receiving: anInputTensor [

	^ self new initializeOfSize: aFilter kernelSized: aTensorShape receiving: anInputTensor
]

{ #category : #configuring }
Conv2DLayerBuilder >> activatedBy: anActivation [

	activation := anActivation
]

{ #category : #configuring }
Conv2DLayerBuilder >> activatedByRelu [

	self activatedBy: ReLU
]

{ #category : #building }
Conv2DLayerBuilder >> build [
	| layer numberOfInputFeatures |

	inputSizeAsserter value.
	numberOfInputFeatures := inputSize
		ifNil: [ input outputShape ]
		ifNotNil: [ inputSize asTensorShape withUnknowBatchDimension ].

	layer := Conv2DLayer
		filtering: input
		shaped: numberOfInputFeatures 
		withKernelLike:
			(ConvolutionKernelSpecification
				totalFilters: filters
				sized: kernelShape
				initializedWith: kernelInitializer).

	activation ifNotNil: [ layer := activation activating: layer ].

	^ layer
]

{ #category : #initialization }
Conv2DLayerBuilder >> initializeOfSize: anInteger kernelSized: aTensorShape receiving: anInputTensor [ 
	
	filters := anInteger. 
	kernelShape := aTensorShape.
	input := anInputTensor
]

{ #category : #configuring }
Conv2DLayerBuilder >> inputSize: aNumberOfInputFeatures [

	inputSize := aNumberOfInputFeatures
]

{ #category : #configuring }
Conv2DLayerBuilder >> kernelInitializedWith: aFilterTensor [ 
	
	kernelInitializer := ConstantInitializer with: aFilterTensor
]
