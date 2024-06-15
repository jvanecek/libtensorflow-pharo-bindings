Class {
	#name : #TensorFlowTutorialExamples,
	#superclass : #Object,
	#category : #NeuralNetworkTrainingLaboratory
}

{ #category : #Examples }
TensorFlowTutorialExamples class >> classifyingClothesImages [
	" Example from https://www.tensorflow.org/tutorials/keras/classification.
	The idea is to get the same results as the Experiment 2 in
	https://colab.research.google.com/drive/1wC0GzDcgHwf227Ivs5TIbirBPD3BqBdg#scrollTo=4M3Oli63F06p
	"

	| tf sample model summary |

	tf := TensorFlowComputation new.

	sample :=
		(SampleDatasetComputationAware
			on: tf
			transformingFeaturesWith: [:features | features / 255.0]
			transformingLabelsWith: [:labels | labels]
			applying: [:dataset | dataset inBatchesOf: 32])
				bindSetsFrom: DatasetProvider current fashionDataset.

	model :=
		(SequentialModelBuilder on: tf)
			addFlattenLayerSized: #(28 28) asTensorShape;
			addDenseLayerSized: 128 builtWith: [:layer | layer activatedByRelu];
			addDenseLayerSized: 10 builtWith: [:layer | ];
			buildApplyingToLogits: [:logits | logits].

	summary :=
		(NeuralNetworkTrainer on: tf)
			minimizeSparseCategoricalCrossEntropyUsing: Adam new;
			stopTrainingWhen: (CompletedNumberOfEpochs after: 10);
			trackMetricWith: SparseCategoricalPredictionAccuracyTracker new;
			trackMetricWith: (TensorboardExperimentTracker storingTo: 'experiment-2/vast');
			train: model toFit: sample.

	summary inspect.

	^TrainingSummaryMetricsDumper new
		stringOfMetricsIn: summary
		knownAs: { 'loss' .  SparseCategoricalPredictionAccuracyTracker metricKey } 
]

{ #category : #Examples }
TensorFlowTutorialExamples class >> experiment4 [

	| tf sample model summary |

	tf := TensorFlowComputation new.

	sample :=
		(SampleDatasetComputationAware
			on: tf
			transformingFeaturesWith: [:features | (features / 255.0) reshapeTo: #(-1 28 28 1)]
			transformingLabelsWith: [:labels | labels]
			applying: [:dataset | dataset inBatchesOf: 32])
				bindSetsFrom: DatasetProvider current handwrittenDigitsDataset.

	model :=
		(SequentialModelBuilder on: tf)
			addConv2DLayerOutputSized: 32 
				kernelSized: #(3 3) asTensorShape   
				builtWith: [ :layer | layer inputSize: #(28 28 1)];
			addMaxPooling2DLayer;
			addConv2DLayerOutputSized: 64
				kernelSized: #(3 3) asTensorShape 
				builtWith: [ :layer | ];
			addMaxPooling2DLayer;
			addFlattenLayerSized: nil;
			addDenseLayerSized: 128 builtWith: [:layer | layer activatedByRelu];
			addDenseLayerSized: 10 builtWith: [:layer | layer activatedBySoftmax];
			buildApplyingToLogits: [:logits | logits argMaxOnRows ].
	
	summary :=
		(NeuralNetworkTrainer on: tf)
			minimizeSparseCategoricalCrossEntropyUsing: RootMeanSquaredPropagation new;
			stopTrainingWhen: (CompletedNumberOfEpochs after: 5);
			trackMetricWith: SparseCategoricalPredictionAccuracyTracker new;
			trackMetricWith: (TensorboardExperimentTracker storingTo: 'experiment-4/pharo');
			train: model toFit: sample.

	summary inspect.

	^TrainingSummaryMetricsDumper new
		stringOfMetricsIn: summary
		knownAs: { 'loss' .  SparseCategoricalPredictionAccuracyTracker metricKey } 
]
