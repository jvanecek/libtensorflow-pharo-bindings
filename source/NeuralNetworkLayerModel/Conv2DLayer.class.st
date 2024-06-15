Class {
	#name : #Conv2DLayer,
	#superclass : #SequentialModelLayer,
	#instVars : [
		'input',
		'trainableVariables'
	],
	#category : #NeuralNetworkLayerModel
}

{ #category : #'Instance Creation' }
Conv2DLayer class >> filtering: anInput shaped: anInputShape withKernelLike: aConvolutionKernelSpecification [

	^ self new
		initializeFiltering: anInput
		shaped: anInputShape
		withKernelLike: aConvolutionKernelSpecification
]

{ #category : #'Instance Creation' }
Conv2DLayer class >> filtering: anInput withKernelLike: aConvolutionKernelSpecification [

	^ self
		filtering: anInput
		shaped: anInput outputShape
		withKernelLike: aConvolutionKernelSpecification
]

{ #category : #Accessing }
Conv2DLayer >> currentComputation [

	^input currentComputation
]

{ #category : #Initialization }
Conv2DLayer >> defaultPaddingTechnique [

	^ Conv2D noPadding
]

{ #category : #Initialization }
Conv2DLayer >> defaultStride [

	^#(1 1)
]

{ #category : #Initialization }
Conv2DLayer >> initializeFiltering: anInput 
	shaped: anInputShape
	withKernelLike: aConvolutionKernelSpecification [

	| filter |

	input := anInput.
	filter :=
		VariableTensor
			on: self currentComputation
			named: 'conv2d-filter'
			of: anInput outputType
			shaped: (
				TensorShape withDimensionsSized: (
					(OrderedCollection new)
						addAll: aConvolutionKernelSpecification kernelShape;
						add: anInputShape channelDimension;
						add: aConvolutionKernelSpecification amountOfFilters;
						asArray))
			initializedWith: aConvolutionKernelSpecification variableInitializer.
			
	value :=
		Conv2D
			on: self currentComputation
			filtering: anInput
			with: filter
			shiftedBy: self defaultStride
			paddedAccording: self defaultPaddingTechnique. 
			
	trainableVariables := OrderedCollection with: filter
]

{ #category : #Accessing }
Conv2DLayer >> inputVariableName [

	^input operationName
]

{ #category : #accessing }
Conv2DLayer >> trainableVariables [
	
	^ trainableVariables
]
