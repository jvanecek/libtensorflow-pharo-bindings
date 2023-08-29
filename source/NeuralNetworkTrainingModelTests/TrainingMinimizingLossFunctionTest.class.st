Class {
	#name : #TrainingMinimizingLossFunctionTest,
	#superclass : #TensorFlowComputationBasedTest,
	#category : #NeuralNetworkTrainingModelTests
}

{ #category : #'Not categorized' }
TrainingMinimizingLossFunctionTest class >> isAbstract [

	^self name = #TrainingMinimizingLossFunctionTest
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> accuracyTracker [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> expectedLabels [

	^#(0 1 0 0) asInt32Tensor
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> expectedLogitsAfterOneEpoch [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> expectedLossAfterOneEpoch [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> expectedLossValueThroughTenEpochs [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> expectedProbabilityByLabel [

	^#((0 1) (1 0) (0 1) (1 1)) asFloatTensor
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> expectedWeightAfterOneEpoch [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> inputTensor [

	^#((0 0 1) (0 1 1) (1 0 0) (1 1 1)) asFloatTensor
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> modelWithTwoOutputUnits [

	^(SequentialModelBuilder on: tf)
		addDenseLayerSized: 2
			builtWith: [:layer |
				layer
					inputSize: 3;
					weightInitializedToZero;
					biasInitializedTo: #(0.2 0.8)];
		buildApplyingToLogits: [:logits | logits]
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> neuralNetworkTrainer [

	self subclassResponsibility
]

{ #category : #Accessing }
TrainingMinimizingLossFunctionTest >> targetTensor [

	self subclassResponsibility
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> testAccuracyAfterOneEpoch [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self neuralNetworkTrainer
			trackMetricWith: self accuracyTracker;
			stopTrainingWhen: (CompletedNumberOfEpochs after: 1);
			train: model toFit: self trainingDataset.

	self
		assert: (summary trainingMetricKnownAs: self accuracyTracker class metricKey)
		isArrayCloseTo: self expectedAccuracyAfterOneEpoch
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> testAccuracyThroughTenEpochs [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self neuralNetworkTrainer
			trackMetricWith: self accuracyTracker;
			stopTrainingWhen: (CompletedNumberOfEpochs after: 10);
			train: model toFit: self trainingDataset.

	self
		assert: (summary trainingMetricKnownAs: self accuracyTracker class metricKey)
		isArrayCloseTo: self expectedAccuracyThroughTenEpochs
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> testFittingLoggerToFile [

	| model inputInBatches fileName |

	model := self modelWithTwoOutputUnits.

	inputInBatches :=
		(SampleDatasetComputationAware on: tf applying: [:dataset | dataset inBatchesOf: 2])
			bindSetsFrom: self trainingAndValidationDataset.

	fileName := 'testFittingLoggerToFile.txt'.
	[
		self neuralNetworkTrainer
			trackMetricWith: (NeuralNetworkFittingLogger toFileNamed: fileName);
			stopTrainingWhen: (CompletedNumberOfEpochs after: 2);
			train: model toFit: inputInBatches.

		fileName asFileReference readStreamDo: [:stream |
			self assert: (stream contents subStrings: String crlf) size equals: 25]]
				ensure: [fileName asFileReference deleteIfAbsent: []]
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> testLogitsAfterOneEpoch [

	| model |

	model := self modelWithTwoOutputUnits.
	self neuralNetworkTrainer
		stopTrainingWhen: (CompletedNumberOfEpochs after: 1);
		train: model toFit: self trainingDataset.

	self
		assert: (
			model logits computeWith: (
				Dictionary new
					at: 'dense/input' put: self inputTensor;
					yourself))
		isMatrixCloseTo: self expectedLogitsAfterOneEpoch
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> testLossValueAfterOneEpoch [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self neuralNetworkTrainer
			stopTrainingWhen: (CompletedNumberOfEpochs after: 1);
			train: model toFit: self trainingDataset.

	self
		assertOutputOf:
			(summary lossValueWhenPredictingFrom: self inputTensor andExpectedIs: self targetTensor)
		isFloatScalarCloseTo: self expectedLossAfterOneEpoch
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> testLossValueThroughTenEpochs [

	| model summary |

	model := self modelWithTwoOutputUnits.
	summary :=
		self neuralNetworkTrainer
			stopTrainingWhen: (CompletedNumberOfEpochs after: 10);
			train: model toFit: self trainingDataset.

	self
		assert: summary historicalTrainingLoss
		isArrayCloseTo: self expectedLossValueThroughTenEpochs
]

{ #category : #Tests }
TrainingMinimizingLossFunctionTest >> testWeightAfterOneEpoch [

	| model |

	model := self modelWithTwoOutputUnits.
	self neuralNetworkTrainer
		stopTrainingWhen: (CompletedNumberOfEpochs after: 1);
		train: model toFit: self trainingDataset.

	self
		assertOutputOf: model trainableVariables first
		isMatrixCloseTo: self expectedWeightAfterOneEpoch
]
