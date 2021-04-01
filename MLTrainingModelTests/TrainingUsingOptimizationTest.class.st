Class {
	#name : #TrainingUsingOptimizationTest,
	#superclass : #TensorFlowComputationBasedTest,
	#category : 'MLTrainingModelTests'
}

{ #category : #Accessing }
TrainingUsingOptimizationTest class >> isAbstract [

	^self name = #TrainingUsingOptimizationTest
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> expectedLabels [

	^#(0 1 0 0) asInt32Tensor
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> expectedLossWhenMinimizingCategoricalCrossEntropy [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> expectedLossWhenMinimizingMeanSquaredError [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> expectedLossWhenMinimizingSparseCategoricalCrossEntropy [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> expectedProbabilityByLabel [

	^#((0 1) (1 0) (0 1) (1 1)) asFloatTensor
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> inputDatasetWithLabels [

	^SampleDataset new
		bindTrainingSetTo: #((0 0 1) (0 1 1) (1 0 0) (1 1 1)) asFloatTensor
			andLabelsTo: self expectedLabels;
		yourself
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> inputDatasetWithLabelsProbabilities [

	^SampleDataset new
		bindTrainingSetTo: #((0 0 1) (0 1 1) (1 0 0) (1 1 1)) asFloatTensor
			andLabelsTo: self expectedProbabilityByLabel;
		yourself
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> modelWithTwoOutputUnits [

	^(SequentialModelBuilder on: tf)
		addDenseLayerSized: 2
			builtWith: [:layer |
				layer
					inputSize: 3;
					weightInitializedToZero;
					biasInitializedTo: #(0.2 0.8)];
		buildApplyingToLogits: [:logits | logits argMaxOnRows]
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> optimizationAlgorithm [

	self subclassResponsibility
]

{ #category : #Tests }
TrainingUsingOptimizationTest >> testMinimizingCategoricalCrossEntropy [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self trainerMinimizingCategoricalCrossEntropy
			stopTrainingWhen: (CompletedNumberOfTraining after: 5);
			train: model toFit: self inputDatasetWithLabelsProbabilities.

	self
		assert: summary historicalTrainingLoss
		isArrayCloseTo: self expectedLossWhenMinimizingCategoricalCrossEntropy
]

{ #category : #Tests }
TrainingUsingOptimizationTest >> testMinimizingMeanSquaredError [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self trainerMinimizingMeanSquaredError
			stopTrainingWhen: (CompletedNumberOfTraining after: 5);
			train: model toFit: self inputDatasetWithLabelsProbabilities.

	self
		assert: summary historicalTrainingLoss
		isArrayCloseTo: self expectedLossWhenMinimizingMeanSquaredError
]

{ #category : #Tests }
TrainingUsingOptimizationTest >> testMinimizingSparseCategoricalCrossEntropy [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self trainerMinimizingSparseCategoricalCrossEntropy
			stopTrainingWhen: (CompletedNumberOfTraining after: 5);
			train: model toFit: self inputDatasetWithLabels.

	self
		assert: summary historicalTrainingLoss
		isArrayCloseTo: self expectedLossWhenMinimizingSparseCategoricalCrossEntropy
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> trainerMinimizingCategoricalCrossEntropy [

	^(NeuralNetworkTrainer on: tf)
		minimizeCategoricalCrossEntropyUsing: self optimizationAlgorithm;
		yourself
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> trainerMinimizingMeanSquaredError [

	^(NeuralNetworkTrainer on: tf)
		minimizeMeanSquaredErrorUsing: self optimizationAlgorithm;
		yourself
]

{ #category : #Accessing }
TrainingUsingOptimizationTest >> trainerMinimizingSparseCategoricalCrossEntropy [

	^(NeuralNetworkTrainer on: tf)
		minimizeSparseCategoricalCrossEntropyUsing: self optimizationAlgorithm;
		yourself
]
