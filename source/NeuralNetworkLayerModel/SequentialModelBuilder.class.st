Class {
	#name : #SequentialModelBuilder,
	#superclass : #Object,
	#instVars : [
		'tf',
		'layers'
	],
	#category : #NeuralNetworkLayerModel
}

{ #category : #'Instance Creation' }
SequentialModelBuilder class >> new [

	^self on: TensorFlowComputation new
]

{ #category : #'Instance Creation' }
SequentialModelBuilder class >> on: aTensorFlowComputation [

	^super new initializeOn: aTensorFlowComputation
]

{ #category : #Configuring }
SequentialModelBuilder >> addConv2DLayerOutputSized: anOutputSize kernelSized: aTensorShape builtWith: aBlock [
	 
	self
		inScopeNamed: 'conv2d'
		withCountOf: Conv2DLayer
		do: [| input layerBuilder |
			input := layers isEmpty ifTrue: [tf floatInputNamed: 'input'] ifFalse: [layers last].
			layerBuilder := 
				Conv2DLayerBuilder 
					ofSize: anOutputSize 
					kernelSized: aTensorShape 
					receiving: input.
			layers isEmpty ifFalse: [layerBuilder makeInputSizeOptional].
			aBlock cull: layerBuilder.
			self addLayer: layerBuilder build]
]

{ #category : #Configuring }
SequentialModelBuilder >> addDenseLayerSized: anOutputSize builtWith: aBlock [

	self
		inScopeNamed: 'dense'
		withCountOf: DenseLayer
		do: [| input layerBuilder |
			input := layers isEmpty ifTrue: [tf floatInputNamed: 'input'] ifFalse: [layers last].
			layerBuilder := DenseLayerBuilder ofSize: anOutputSize receiving: input.
			layers isEmpty ifFalse: [layerBuilder makeInputSizeOptional].
			aBlock value: layerBuilder.
			self addLayer: layerBuilder build]
]

{ #category : #Configuring }
SequentialModelBuilder >> addFlattenLayer [
	layers isEmpty
		ifTrue: [ AssertionFailure
				signal:
					'Should use addFlattenLayerSized: message, since there is no layer to deduce the size from' ].
	
	self
		inScopeNamed: 'flatten'
		withCountOf: FlattenLayer
		do: [ | input |
			input := layers last. 
			self addLayer: (FlattenLayer receiving: input) ]
]

{ #category : #Configuring }
SequentialModelBuilder >> addFlattenLayerSized: aTensorShape [
	layers isEmpty
		ifFalse: [ AssertionFailure
				signal:
					'Should use addFlattenLayer message, since the input size can be deduced from the last layer' ].
	
	self
		inScopeNamed: 'flatten'
		withCountOf: FlattenLayer
		do: [ | input |
			input := InputTensor
				on: tf
				named: 'input'
				of: FloatDataType new
				shaped: aTensorShape withUnknowBatchDimension.
			self addLayer: (FlattenLayer receiving: input) ]
]

{ #category : #'private-configuring' }
SequentialModelBuilder >> addLayer: aDenseLayer [

	layers add: aDenseLayer
]

{ #category : #Configuring }
SequentialModelBuilder >> addMaxPooling2DLayer [

	self
		inScopeNamed: 'maxPool2d'
		withCountOf: MaxPooling2D
		do: [ | input layerBuilder |

			input := layers isEmpty
				ifTrue: [ tf floatInputNamed: 'input' ]
				ifFalse: [ layers last ].
			layerBuilder := MaxPooling2DLayerBuilder receiving: input.
			self addLayer: layerBuilder build
			]
]

{ #category : #Building }
SequentialModelBuilder >> build [

	^self buildApplyingToLogits: [:logits | logits]
]

{ #category : #Building }
SequentialModelBuilder >> buildApplyingToLogits: aBlock [

	^SequentialModel composedOf: layers applyingToLogits: aBlock
]

{ #category : #'private-configuring' }
SequentialModelBuilder >> inScopeNamed: aLayerName withCountOf: aLayerClass do: aBlock [

	| denseCount |

	denseCount := layers count: [:layer | layer isA: aLayerClass].
	tf
		inScopeNamed: (
			denseCount = 0
				ifTrue: [aLayerName]
				ifFalse: ['<1s>_<2p>' expandMacrosWith: aLayerName with: denseCount])
		do: aBlock
]

{ #category : #Initialization }
SequentialModelBuilder >> initializeOn: aTensorFlowComputation [

	tf := aTensorFlowComputation.
	layers := OrderedCollection new
]
