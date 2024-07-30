Class {
	#name : #Conv2DModelTest,
	#superclass : #TensorFlowComputationBasedTest,
	#category : #NeuralNetworkTrainingModelTests
}

{ #category : #'private - accessing' }
Conv2DModelTest >> inputForConv2D [
	^ TFTensor
		newTyped: FloatDataType new
		shaped: #(1 28 28 1) asTensorShape
		containing: (Array new: 28 * 28 withAll: 1)
]

{ #category : #tests }
Conv2DModelTest >> testIngInputSizeMustBeSpecified [
	self
		should: [ (SequentialModelBuilder on: tf)
				addConv2DLayerOutputSized: 32
					kernelSized: #(3 3) asTensorShape
					builtWith: [  ];
				build ]
		raise: AssertionFailure
		withDescription: #'Input size must be defined!'
]

{ #category : #tests }
Conv2DModelTest >> testModelWith1Layer [
	| model output |
	model := (SequentialModelBuilder on: tf)
		addConv2DLayerOutputSized: 32
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | layer inputSize: #(28 28 1) asTensorShape ];
		build.
	output := model predictFrom: self inputForConv2D.
	self assert: output shape equals: #(1 26 26 32) asTensorShape
]

{ #category : #tests }
Conv2DModelTest >> testModelWith2Layer [
	| model output |
	model := (SequentialModelBuilder on: tf)
		addConv2DLayerOutputSized: 32
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | layer inputSize: #(28 28 1) asTensorShape ];
		addMaxPooling2DLayer;
		build.
	output := model predictFrom: self inputForConv2D.
	self assert: output shape equals: #(1 13 13 32) asTensorShape
]

{ #category : #tests }
Conv2DModelTest >> testModelWith3Layers [
	| model output |
	model := (SequentialModelBuilder on: tf)
		addConv2DLayerOutputSized: 32
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | layer inputSize: #(28 28 1) asTensorShape ];
		addMaxPooling2DLayer;
		addConv2DLayerOutputSized: 64
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | ];
		build.
	output := model predictFrom: self inputForConv2D.
	self assert: output shape equals: #(1 11 11 64) asTensorShape
]

{ #category : #tests }
Conv2DModelTest >> testModelWith4Layers [

	| model output |
	model := (SequentialModelBuilder on: tf)
		addConv2DLayerOutputSized: 32
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | layer inputSize: #(28 28 1) asTensorShape ];
		addMaxPooling2DLayer;
		addConv2DLayerOutputSized: 64
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | ];
		addMaxPooling2DLayer;
		build.
	output := model predictFrom: self inputForConv2D.
	self assert: output shape equals: #(1 5 5 64) asTensorShape
]

{ #category : #tests }
Conv2DModelTest >> testModelWith5Layers [

	| model output |
	model := (SequentialModelBuilder on: tf)
		addConv2DLayerOutputSized: 32
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | layer inputSize: #(28 28 1) asTensorShape ];
		addMaxPooling2DLayer;
		addConv2DLayerOutputSized: 64
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | ];
		addMaxPooling2DLayer;
		addFlattenLayer; 
		build.
	output := model predictFrom: self inputForConv2D.
	self assert: output shape equals: #(1 1600) asTensorShape 
	
]

{ #category : #tests }
Conv2DModelTest >> testModelWith6Layers [

	| model output |
	model := (SequentialModelBuilder on: tf)
		addConv2DLayerOutputSized: 32
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | layer inputSize: #(28 28 1) asTensorShape ];
		addMaxPooling2DLayer;
		addConv2DLayerOutputSized: 64
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | ];
		addMaxPooling2DLayer;
		addFlattenLayer; 
		addDenseLayerSized: 128 builtWith: [ :layer | ]; 
		build.
	output := model predictFrom: self inputForConv2D.
	self assert: output shape equals: #(1 128) asTensorShape 
	
]

{ #category : #tests }
Conv2DModelTest >> testModelWith7Layers [

	| model output |
	model := (SequentialModelBuilder on: tf)
		addConv2DLayerOutputSized: 32
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | layer inputSize: #(28 28 1) asTensorShape ];
		addMaxPooling2DLayer;
		addConv2DLayerOutputSized: 64
			kernelSized: #(3 3) asTensorShape
			builtWith: [ :layer | ];
		addMaxPooling2DLayer;
		addFlattenLayer; 
		addDenseLayerSized: 128 builtWith: [ :layer | ]; 
		addDenseLayerSized: 10 builtWith: [ :layer | ]; 	
		build.
	output := model predictFrom: self inputForConv2D.
	self assert: output shape equals: #(1 10) asTensorShape 
	
]
